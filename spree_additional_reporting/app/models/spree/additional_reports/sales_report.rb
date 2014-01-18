module Spree::AdditionalReports
  class SalesReport < IntervalReport
    validates_presence_of :date_from, :date_to
    attr_accessor :group_by_period
    validates_inclusion_of :group_by_period, :in => %w( date week month year )

    def rows
      query = " 
select p.id product_id, p.name product_name, p.permalink product_permalink, sum(si.items_qty) total_qty, sum(si.items_qty * si.item_total_price) total_amount, mv.sku product_sku, si.order_period, si.order_date
from (
	select 
		ovi.variant_id,
		ovi.order_variant_items_qty items_qty,
		ovi.item_price + round(order_adjustments_total / order_items_qty, 2) item_total_price,
    o.order_period,
    o.order_date
	from (
		select o.id order_id, 
           sum(a.amount) order_adjustments_total, 
           #{group_by_period}(o.completed_at) order_period,
           date(o.completed_at) order_date
		from #{Spree::Order.table_name} o,
			 #{Spree::Adjustment.table_name} a
		where o.completed_at is not null 
			  and o.state != 'canceled'
			  and o.hto = 0
        and o.completed_at < adddate(#{ActiveRecord::Base.sanitize(date_to)}, interval 1 day)
        and o.completed_at >= timestamp(#{ActiveRecord::Base.sanitize(date_from)})
			  and a.adjustable_id = o.id
			  and a.originator_type not in ('Spree::TaxRate', 'Spree::ShippingMethod')
			  and a.eligible = 1
		group by o.id
	) o,
	(	
		select o.id order_id, sum(i.quantity) order_items_qty
		from #{Spree::Order.table_name} o,
			 #{Spree::LineItem.table_name} i
		where o.completed_at is not null 
			  and o.state != 'canceled'
			  and o.hto = 0
        and o.completed_at < adddate(#{ActiveRecord::Base.sanitize(date_to)}, interval 1 day)
        and o.completed_at >= timestamp(#{ActiveRecord::Base.sanitize(date_from)})
			  and i.order_id = o.id
		group by o.id
	) oi,
	(	
		select o.id order_id, i.variant_id, sum(i.quantity) order_variant_items_qty, i.price item_price
		from #{Spree::Order.table_name} o,
			 #{Spree::LineItem.table_name} i
		where o.completed_at is not null 
			  and o.state != 'canceled'
			  and o.hto = 0
        and o.completed_at < adddate(#{ActiveRecord::Base.sanitize(date_to)}, interval 1 day)
        and o.completed_at >= timestamp(#{ActiveRecord::Base.sanitize(date_from)})
			  and i.order_id = o.id
		group by o.id, i.variant_id
	) ovi
	where o.order_id = oi.order_id
		and o.order_id = ovi.order_id
) si, #{Spree::Variant.table_name} v, #{Spree::Product.table_name} p, #{Spree::Variant.table_name} mv
where si.variant_id = v.id 
      and p.id = v.product_id 
      and p.id = mv.product_id 
      and mv.is_master = 1
group by si.order_period
order by si.order_period desc 
      "
      flat_data = ActiveRecord::Base.connection.select_all(query)
      self.class.group_rows(flat_data, ['order_period'], Proc.new { |t, r| { 
        'total_qty' => t['total_qty'].to_i + r['total_qty'].to_i,
        'total_amount' => t['total_amount'].to_f + r['total_amount'].to_f
      }}) << flat_data
    end
  end
end
