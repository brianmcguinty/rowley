module SpreeLensPrescriptions
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_lens_prescriptions'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |generator|
      generator.template_engine :haml
      generator.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: true,
        request_specs: true
      generator.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer 'spree.register.calculators' do |app|
      app.config.spree.calculators.add_class('lens_meta_prescriptions')
      app.config.spree.calculators.lens_meta_prescriptions = [Spree::Calculator::LensMetaPrescriptionAddition]
      app.config.spree.calculators.add_class('order_subscription_discounts')
      app.config.spree.calculators.order_subscription_discounts = [Spree::Calculator::SubscriptionDiscount]
      app.config.spree.calculators.tax_rates = [Spree::Calculator::TaxWithLensPrescription]
    end

    config.to_prepare &method(:activate).to_proc
  end
end
