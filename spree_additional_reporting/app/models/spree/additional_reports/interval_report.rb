module Spree::AdditionalReports
  class IntervalReport < Report
    attr_reader :date_from
    attr_reader :date_to


    def date_from=(v)
      @date_from = v.to_date rescue nil
    end

    def date_to=(v)
      @date_to = v.to_date rescue nil
    end
  end
end
