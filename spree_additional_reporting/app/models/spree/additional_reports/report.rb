module Spree::AdditionalReports
  class Report
    include ActiveModel::Conversion
    include ActiveModel::Validations
    extend ActiveModel::Naming


    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def persisted?
      false
    end

    def rows
      []
    end

    private

    def self.group_rows(rows, group_field_names, totals_proc = nil)
      grand_totals = {}
      gr = rows.inject({}) do |grouped_rows, row| 
        grand_totals = totals_proc.call(grand_totals, row) if totals_proc
        merge_row(grouped_rows, nested_hash(row, group_field_names.dup, totals_proc), row, totals_proc) 
      end
      [gr, grand_totals]
    end

    def self.nested_hash(row, group_field_names, totals_proc)
      item = group_field_names.shift
      if group_field_names.present?
        nh = nested_hash(row, group_field_names, totals_proc)
        nh[:_totals] = if totals_proc then totals_proc.call(nh[:_totals] || {}, row).merge({ :_last_row => row }) else { :_last_row => row } end
        { row[item] => nh }
      else
        { row[item] => row }
      end
    end

    def self.merge_row(hash, row_hash, row, totals_proc)
      merge_row!(hash.dup, row_hash, row, totals_proc)
    end

    def self.merge_row!(hash, row_hash, row, totals_proc)
      row_hash.each_pair do |k,v|
        if k == :_totals
          hash[k] = if totals_proc then totals_proc.call(hash[k] || {}, row).merge({ :_last_row => row }) else { :_last_row => row } end
        else
          hash[k] = if hash[k].is_a?(Hash) && v.is_a?(Hash)
                      then 
                      r = merge_row(hash[k], v, row, totals_proc) 
                      r
                    else 
                      v 
                    end
        end
      end
      hash
    end

  end
end
