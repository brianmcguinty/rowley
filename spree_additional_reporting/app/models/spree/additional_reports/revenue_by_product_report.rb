module Spree::AdditionalReports
  class RevenueByProductReport < IntervalReport
    validates_presence_of :date_from, :date_to

    def rows
      query = " 
select r.*, vo.presentation variant_color
from (
	select p.id product_id, p.name product_name, p.permalink product_permalink, sum(si.items_qty) total_qty, sum(si.items_qty * si.item_total_price) total_amount, mv.sku product_sku, v.id variant_id, v.sku_upc variant_upc
	from (
		select 
			ovi.variant_id,
			ovi.order_variant_items_qty items_qty,
			ovi.item_price 
                    + round(o.order_lens_total / order_items_qty, 2)
                    + round(order_misc_adjustments_total * ovi.item_price / item_total, 2) 
item_total_price
		from (
			select o.id order_id, 
                   sum(if (a.originator_type = 'Spree::LensMetaPrescription ', a.amount, 0)) order_lens_total, 
                   sum(if (a.originator_type != 'Spree::LensMetaPrescription ', a.amount, 0)) order_misc_adjustments_total,
                   o.item_total
			from spree_orders o,
				 spree_adjustments a
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
			from spree_orders o,
				 spree_line_items i
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
			from spree_orders o,
				 spree_line_items i
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
	) si, spree_variants v, spree_products p, spree_variants mv
	where si.variant_id = v.id 
		  and p.id = v.product_id 
		  and p.id = mv.product_id 
		  and mv.is_master = 1
          and v.is_master = 0
	group by v.id
) r
left join (select ovv.variant_id, ov.presentation
          from spree_option_values_variants ovv
          ,spree_option_values ov
          ,spree_option_types ot
          where ov.id = ovv.option_value_id
          and ot.id=ov.option_type_id
          and ot.name='frames-color') vo on r.variant_id = vo.variant_id
group by r.variant_id
order by product_name, r.variant_id desc 
      "
      flat_data = ActiveRecord::Base.connection.select_all(query)
      self.class.group_rows(flat_data, ['variant_id'], Proc.new { |t, r| { 
        'total_qty' => t['total_qty'].to_i + r['total_qty'].to_i,
        'total_amount' => t['total_amount'].to_f + r['total_amount'].to_f
      }}) << flat_data
    end
  end
end
