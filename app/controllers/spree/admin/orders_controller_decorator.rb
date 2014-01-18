if defined?(Spree::Admin::OrdersController)
  Spree::Admin::OrdersController.class_eval do
    before_filter :check_authorization

    def new
      @order = Spree::Order.create(:hto => params[:hto])
      respond_with(@order)
    end

    def index
      params[:q] ||= {}
      params[:q][:completed_at_not_null] ||= '1' if Spree::Config[:show_only_complete_orders_by_default]
      @show_only_completed = params[:q][:completed_at_not_null].present?
      params[:q][:s] ||= @show_only_completed ? 'completed_at desc' : 'created_at desc'

      # As date params are deleted if @show_only_completed, store
      # the original date so we can restore them into the params
      # after the search
      created_at_gt = params[:q][:created_at_gt]
      created_at_lt = params[:q][:created_at_lt]

      params[:q].delete(:inventory_units_shipment_id_null) if params[:q][:inventory_units_shipment_id_null] == "0"

      if !params[:q][:created_at_gt].blank?
        params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue ""
      end

      if !params[:q][:created_at_lt].blank?
        params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
      end

      if @show_only_completed
        params[:q][:completed_at_gt] = params[:q].delete(:created_at_gt)
        params[:q][:completed_at_lt] = params[:q].delete(:created_at_lt)
      end

      # hide 'canceled' orders
      params[:q][:hide_canceled_orders] ||= '1'
      @hide_canceled_orders = params[:q][:hide_canceled_orders].present?
      if @hide_canceled_orders
        params[:q][:state_not_eq] = 'canceled'
      end

      @search = Spree::Order.accessible_by(current_ability, :index).ransack(params[:q])
      #@search = @search.search(:state_not_in => 'cancel')
      @orders = @search.result.includes([:user, :shipments, :payments]).
        page(params[:page]).
        per(params[:per_page] || Spree::Config[:orders_per_page])

      # Restore dates
      params[:q][:created_at_gt] = created_at_gt
      params[:q][:created_at_lt] = created_at_lt

      respond_with(@orders)
    end

    private
      def check_authorization
        action = params[:action].to_sym
        if action.in?(:index, :new)
          authorize! action, Spree::Order
        else
          load_order
          session[:access_token] ||= params[:token]
          resource = @order || Spree::Order.new
          authorize! action, resource, session[:access_token]
        end
      end
  end
end
