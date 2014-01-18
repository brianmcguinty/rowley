module Spree::AdditionalReports
  class HtoConversionReport < IntervalReport
    validates_presence_of :date_from, :date_to

    def rows
      query = "
select count(hto_orders.email) hto_customers_qty, count(orders.email) customers_qty, count(orders.email) / count(hto_orders.email) conversion
from 
(
select email, min(completed_at) dt
from spree_orders
where hto = 1
      and completed_at is not null 
      and state != 'canceled'
      and completed_at < adddate(#{ActiveRecord::Base.sanitize(date_to)}, interval 1 day)
      and completed_at >= timestamp(#{ActiveRecord::Base.sanitize(date_from)})
group by email
) hto_orders left join
(
select email, max(completed_at) dt
from spree_orders
where hto = 0
      and completed_at is not null 
      and state != 'canceled'
      and completed_at < adddate(#{ActiveRecord::Base.sanitize(date_to)}, interval 1 day)
      and completed_at >= timestamp(#{ActiveRecord::Base.sanitize(date_from)})
group by email
) orders on hto_orders.email = orders.email and hto_orders.dt < orders.dt
      "
      ActiveRecord::Base.connection.select_all(query)
    end
  end
end
