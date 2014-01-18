module Spree::AdditionalReports
  class HtoVsSalesReport < IntervalReport
    validates_presence_of :date_from, :date_to
    attr_accessor :mode
    validates :mode, :inclusion => { :in => %w(hto sales hto_vs_sales) }

    def rows
      ActiveRecord::Base.connection.select_all(query)
    end

    private 

    def query
      send("#{mode}_query")
    end

    def sales_query
      "
select q.*, (select sum(count_on_hand) 
             from spree_variants 
             where deleted_at is null 
                   and (id = q.variant_id or same_as_variant_id = q.variant_id or 
                        q.same_as_variant_id = same_as_variant_id or id = q.same_as_variant_id)) real_inventory,
            (select group_concat(distinct t.name) from spree_products_taxons pt, spree_taxons t where t.id = pt.taxon_id and pt.product_id = q.id) frame_type
from (
  select v.id variant_id, p.id, p.name product_name, mv.sku product_sku, si.items_qty units_sold, prc.amount variant_price, v.count_on_hand, vo.presentation variant_color, v.sku_upc variant_upc, v.same_as_variant_id
  from spree_products p 
  join spree_variants v on p.id = v.product_id and v.deleted_at is null
  join spree_variants mv on p.id = mv.product_id and mv.is_master = 1 and v.deleted_at is null
  join spree_prices prc on prc.variant_id = v.id
  left join (
    select i.variant_id, sum(i.quantity) items_qty
    from spree_orders o,
       spree_line_items i
    where o.completed_at is not null 
        and o.state != 'canceled'
        and o.hto = 0
          and o.completed_at < adddate(#{ActiveRecord::Base.sanitize(date_to)}, interval 1 day)
          and o.completed_at >= timestamp(#{ActiveRecord::Base.sanitize(date_from)})
        and i.order_id = o.id
    group by i.variant_id
  ) si on si.variant_id = v.id 
  left join (select ovv.variant_id, ov.presentation
            from spree_option_values_variants ovv
            ,spree_option_values ov
            ,spree_option_types ot
            where ov.id = ovv.option_value_id
            and ot.id=ov.option_type_id
            and ot.name='frames-color') vo on v.id = vo.variant_id
  where p.deleted_at is null and v.is_master = 0
  group by v.id
) q
order by product_name, variant_id
      "
    end

    def hto_query
      "
select q.*, (select sum(count_on_hand) 
             from spree_variants 
             where deleted_at is null 
                   and (id = q.variant_id or same_as_variant_id = q.variant_id or 
                        q.same_as_variant_id = same_as_variant_id or id = q.same_as_variant_id)) real_inventory,
            (select group_concat(distinct t.name) from spree_products_taxons pt, spree_taxons t where t.id = pt.taxon_id and pt.product_id = q.id) frame_type
from (
  select v.id variant_id, p.id, p.name product_name, mv.sku product_sku, si.items_qty hto_units_sent, prc.amount variant_price, v.count_on_hand, vo.presentation variant_color, v.sku_upc variant_upc, iu.hto_outstanding_qty, v.same_as_variant_id
  from spree_products p 
  join spree_variants v on p.id = v.product_id and v.deleted_at is null
  join spree_variants mv on p.id = mv.product_id and mv.is_master = 1 and v.deleted_at is null
  join spree_prices prc on prc.variant_id = v.id
  left join (
    select i.variant_id, sum(i.quantity) items_qty
    from spree_orders o,
       spree_line_items i
    where o.completed_at is not null 
        and o.state != 'canceled'
        and o.hto = 1
          and o.completed_at < adddate(#{ActiveRecord::Base.sanitize(date_to)}, interval 1 day)
          and o.completed_at >= timestamp(#{ActiveRecord::Base.sanitize(date_from)})
        and i.order_id = o.id
    group by i.variant_id
  ) si on si.variant_id = v.id 
  left join (
    select iu.variant_id, count(*) hto_outstanding_qty
    from spree_orders o
       join spree_inventory_units iu on iu.order_id = o.id
       join spree_shipments s on s.id = iu.shipment_id
       left join spree_return_authorizations ra on ra.id = iu.return_authorization_id
    where o.completed_at is not null 
          and o.state != 'canceled'
          and o.hto = 1
          and iu.state in ('shipped', 'returned')
          and (iu.state = 'shipped' or (ra.created_at >= adddate(#{ActiveRecord::Base.sanitize(date_to)}, interval 1 day)))
          and o.completed_at < adddate(#{ActiveRecord::Base.sanitize(date_to)}, interval 1 day)
          and s.shipped_at < adddate(#{ActiveRecord::Base.sanitize(date_to)}, interval 1 day)
          and o.completed_at >= timestamp('2013-09-18')
    group by iu.variant_id
  ) iu on v.id = iu.variant_id
  left join (select ovv.variant_id, ov.presentation
            from spree_option_values_variants ovv
            ,spree_option_values ov
            ,spree_option_types ot
            where ov.id = ovv.option_value_id
            and ot.id=ov.option_type_id
            and ot.name='frames-color') vo on v.id = vo.variant_id
  where p.deleted_at is null and v.is_master = 0
  group by v.id
) q
order by product_name, variant_id
      "
    end

    def hto_vs_sales_query
      "
select q.*, (select sum(count_on_hand) 
             from spree_variants 
             where deleted_at is null 
                   and (id = q.variant_id or same_as_variant_id = q.variant_id or 
                        q.same_as_variant_id = same_as_variant_id or id = q.same_as_variant_id)) real_inventory,
            (select group_concat(distinct t.name) from spree_products_taxons pt, spree_taxons t where t.id = pt.taxon_id and pt.product_id = q.id) frame_type
from (
  select v.id variant_id, p.id, p.name product_name, mv.sku product_sku, hsi.items_qty hto_units_sent, si.items_qty units_sold, prc.amount variant_price, v.count_on_hand, vo.presentation variant_color, v.sku_upc variant_upc, iu.hto_outstanding_qty, v.same_as_variant_id
  from spree_products p 
  join spree_variants v on p.id = v.product_id and v.deleted_at is null
  join spree_variants mv on p.id = mv.product_id and mv.is_master = 1 and v.deleted_at is null
  join spree_prices prc on prc.variant_id = v.id
  left join (
    select i.variant_id, sum(i.quantity) items_qty
    from spree_orders o,
       spree_line_items i
    where o.completed_at is not null 
          and o.state != 'canceled'
          and o.hto = 0
          and o.completed_at < adddate(#{ActiveRecord::Base.sanitize(date_to)}, interval 1 day)
          and o.completed_at >= timestamp(#{ActiveRecord::Base.sanitize(date_from)})
          and i.order_id = o.id
    group by i.variant_id
  ) si on si.variant_id = v.id 
  left join (
    select i.variant_id, sum(i.quantity) items_qty
    from spree_orders o,
       spree_line_items i
    where o.completed_at is not null 
          and o.state != 'canceled'
          and o.hto = 1
          and o.completed_at < adddate(#{ActiveRecord::Base.sanitize(date_to)}, interval 1 day)
          and o.completed_at >= timestamp(#{ActiveRecord::Base.sanitize(date_from)})
          and i.order_id = o.id
    group by i.variant_id
  ) hsi on hsi.variant_id = v.id 
  left join (
    select iu.variant_id, count(*) hto_outstanding_qty
    from spree_orders o
       join spree_inventory_units iu on iu.order_id = o.id
       join spree_shipments s on s.id = iu.shipment_id
       left join spree_return_authorizations ra on ra.id = iu.return_authorization_id
    where o.completed_at is not null 
          and o.state != 'canceled'
          and o.hto = 1
          and iu.state in ('shipped', 'returned')
          and (iu.state = 'shipped' or (ra.created_at >= adddate(#{ActiveRecord::Base.sanitize(date_to)}, interval 1 day)))
          and o.completed_at < adddate(#{ActiveRecord::Base.sanitize(date_to)}, interval 1 day)
          and s.shipped_at < adddate(#{ActiveRecord::Base.sanitize(date_to)}, interval 1 day)
          and o.completed_at >= timestamp('2013-09-18')
    group by iu.variant_id
  ) iu on v.id = iu.variant_id
  left join (select ovv.variant_id, ov.presentation
            from spree_option_values_variants ovv
            ,spree_option_values ov
            ,spree_option_types ot
            where ov.id = ovv.option_value_id
            and ot.id=ov.option_type_id
            and ot.name='frames-color') vo on v.id = vo.variant_id
  where p.deleted_at is null and v.is_master = 0
  group by v.id
) q
order by q.product_name, q.variant_id
      "
    end
  end
end
