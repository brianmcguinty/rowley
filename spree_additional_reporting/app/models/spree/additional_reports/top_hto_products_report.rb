module Spree::AdditionalReports
  class TopHtoProductsReport < IntervalReport
    validates_presence_of :date_from, :date_to

    def rows
      query = " 
select r.*, vo.presentation variant_color
from (
  select p.id product_id, 
         p.name product_name, 
         mv.sku product_sku, 
         p.permalink product_permalink,
         count(*) qty,
         v.id variant_id,
         v.sku_upc variant_upc
  from spree_variants v, 
       spree_products p,
       spree_orders o,
       spree_line_items li,
       spree_variants mv 
  where p.id = v.product_id
        and o.hto = 1
        and o.completed_at is not null
        and o.state != 'canceled'
        and o.id = li.order_id
        and li.variant_id = v.id
        and o.completed_at < adddate(#{ActiveRecord::Base.sanitize(date_to)}, interval 1 day)
        and o.completed_at >= timestamp(#{ActiveRecord::Base.sanitize(date_from)})
        and p.deleted_at is null
        and v.deleted_at is null
        and mv.product_id = p.id
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
order by r.qty desc
      "
      ActiveRecord::Base.connection.select_all(query)
    end
  end
end
