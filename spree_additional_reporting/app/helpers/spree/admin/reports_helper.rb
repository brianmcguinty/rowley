module Spree::Admin::ReportsHelper
  def display_period(group_by_period, period, date)
    case group_by_period.to_s
    when 'week'
      "#{date.at_beginning_of_week(:sunday)} - #{date.at_end_of_week(:sunday)}"
    when 'month'
      date.strftime('%m/%Y') rescue ''
    else
      period.to_s
    end
  end
end
