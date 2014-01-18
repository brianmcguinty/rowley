module SpreeLockedOrders
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_locked_orders'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end

  module ControllerMixins
    extend ActiveSupport::Concern
    module ClassMethods
      def ensure_order_lock(options = {})
        before_filter :lock_order, options
        define_method('lock_order') do
          if @order.present? 
            if @order.locked_for?(current_user)
              begin
                flash[:error] = "#{t(:order_locked_by)} #{@order.locked_by_user.email}"
                redirect_to :back
              rescue 
                redirect_to admin_order_path(@order)
              end
            else
              @order.lock(current_user)
            end
          end
        end
      end
    end
  end
end

ActionController::Base.send :include, SpreeLockedOrders::ControllerMixins
# p classes
