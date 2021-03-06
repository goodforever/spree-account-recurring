module SpreeAccountRecurring
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_account_recurring'

    config.autoload_paths += %W(#{config.root}/lib)

    # For Spree Master (currently > 3.4)
    if Spree::Core::Engine.const_defined?(:Environment)
      Spree::Core::Engine::Environment.class_eval do
        attr_accessor :recurring_providers
      end
    else
    # For Spree <= 3.4
      Spree::Core::Environment.class_eval do
        attr_accessor :recurring_providers
      end
    end

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

    initializer "spree.register.recurring_providers" do |app|
      app.config.spree.recurring_providers = [Spree::Recurring::StripeRecurring]
    end
  end
end
