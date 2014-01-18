Spree::Admin::ReportsController.class_eval do
  before_filter :register_additional_reports
  # before_filter :basic_report_setup, :actions => [:profit, :revenue, :units, :top_products, :top_customers, :geo_revenue, :geo_units, :count, :top_hto_products]
  layout '/spree/layouts/reports'

  def register_additional_reports
    Spree::Admin::ReportsController::AVAILABLE_REPORTS.clear
    Spree::Admin::ReportsController::AVAILABLE_REPORTS.merge!(ADDITIONAL_REPORTS)
  end
  I18n.locale = Rails.application.config.i18n.default_locale
  I18n.reload!

  ADDITIONAL_REPORTS ||= {}
  [ :sales,
    :revenue_by_product, 
    :revenue_by_product_customers, 
    :top_hto_products, 
    :inventory,
    :hto_vs_sales,
    :hto_conversion
  ].each do |x|
    ADDITIONAL_REPORTS[x] = {
      :name => I18n.t("additional_report.#{x.to_s}"), 
      :description => I18n.t("additional_report.#{x.to_s}")
    }
  end

  def top_hto_products
    respond_to do |wants|
      wants.html do
        @report = Spree::AdditionalReports::TopHtoProductsReport.new
      end
      wants.js do 
        @report = Spree::AdditionalReports::TopHtoProductsReport.new(params[:additional_reports_top_hto_products_report])
        if @report.valid?
          @rows = @report.rows
          render 'result'
        else
          render :js => 'alert("Invalid params")'
        end
      end
      wants.csv do 
        @report = Spree::AdditionalReports::TopHtoProductsReport.new(params[:additional_reports_top_hto_products_report])
        if @report.valid?
          @rows = @report.rows
          init_csv("top_hto_products_#{DateTime.now.to_i}.csv")
          render('top_hto_products_result')
        else
          render :nothing => true
        end
      end
    end
  end

  def inventory
    @report = Spree::AdditionalReports::InventoryReport.new
    @rows = @report.rows
    respond_to do |wants|
      wants.html
      wants.csv
    end
  end

  def revenue_by_product
    respond_to do |wants|
      wants.html do
        @report = Spree::AdditionalReports::RevenueByProductReport.new
      end
      wants.js do 
        @report = Spree::AdditionalReports::RevenueByProductReport.new(params[:additional_reports_revenue_by_product_report])
        if @report.valid?
          @rows = @report.rows
          render 'result'
        else
          render :js => 'alert("Invalid params")'
        end
      end
      wants.csv do 
        @report = Spree::AdditionalReports::RevenueByProductReport.new(params[:additional_reports_revenue_by_product_report])
        if @report.valid?
          @rows = @report.rows.last
          init_csv("revenue_by_product_#{DateTime.now.to_i}.csv")
          render('revenue_by_product_result')
        else
          render :nothing => true
        end
      end
    end
  end

  def revenue_by_product_customers
    respond_to do |wants|
      wants.html do
        @report = Spree::AdditionalReports::RevenueByProductCustomersReport.new
      end
      wants.js do 
        @report = Spree::AdditionalReports::RevenueByProductCustomersReport.new(params[:additional_reports_revenue_by_product_customers_report])
        if @report.valid?
          @rows = @report.rows
          render 'result'
        else
          render :js => 'alert("Invalid params")'
        end
      end
      wants.csv do 
        @report = Spree::AdditionalReports::RevenueByProductCustomersReport.new(params[:additional_reports_revenue_by_product_customers_report])
        if @report.valid?
          @rows = @report.rows.last
          init_csv("revenue_by_product_customers_#{DateTime.now.to_i}.csv")
          render('revenue_by_product_customers_result')
        else
          render :nothing => true
        end
      end
    end
  end
    
  def sales
    respond_to do |wants|
      wants.html do
        @report = Spree::AdditionalReports::SalesReport.new
      end
      wants.js do 
        @report = Spree::AdditionalReports::SalesReport.new(params[:additional_reports_sales_report])
        if @report.valid?
          @rows = @report.rows
          render 'result'
        else
          render :js => 'alert("Invalid params")'
        end
      end
      wants.csv do 
        @report = Spree::AdditionalReports::SalesReport.new(params[:additional_reports_sales_report])
        if @report.valid?
          @rows = @report.rows.last
          init_csv("sales_#{DateTime.now.to_i}.csv")
          render('sales_result')
        else
          render :nothing => true
        end
      end
    end
  end

  def hto_vs_sales
    respond_to do |wants|
      wants.html do
        @report = Spree::AdditionalReports::HtoVsSalesReport.new
      end
      wants.js do 
        @report = Spree::AdditionalReports::HtoVsSalesReport.new(params[:additional_reports_hto_vs_sales_report])
        if @report.valid?
          @rows = @report.rows
          render 'result'
        else
          render :js => 'alert("Invalid params")'
        end
      end
      wants.csv do 
        @report = Spree::AdditionalReports::HtoVsSalesReport.new(params[:additional_reports_hto_vs_sales_report])
        if @report.valid?
          @rows = @report.rows
          init_csv("#{@report.mode}_#{DateTime.now.to_i}.csv")
          render("hto_vs_sales_#{@report.mode}_result")
        else
          render :nothing => true
        end
      end
    end
  end

  def hto_conversion
    respond_to do |wants|
      wants.html do
        @report = Spree::AdditionalReports::HtoConversionReport.new
      end
      wants.js do
        @report = Spree::AdditionalReports::HtoConversionReport.new(params[:additional_reports_hto_conversion_report])
        if @report.valid?
          @rows = @report.rows
          render 'result'
        else
          render :js => 'alert("Invalid params")'
        end
      end
    end
  end

  private
  def init_csv(filename)
    @csv_options = { :force_quotes => true }
    @filename = filename
    @output_encoding = 'UTF-8'
  end
end
