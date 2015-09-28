module SpreeConekta
  class Engine < ::Rails::Engine
    require 'spree'

    engine_name 'spree_gateway'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    if Rails.version >= '3.1'
      initializer :assets do |config|
        Rails.application.config.assets.precompile += %w( spree_conekta.js )
      end
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
    end

    initializer "spree.gateway.payment_methods", after: "spree.register.payment_methods" do |app|
      app.config.spree.payment_methods << Spree::BillingIntegration::ConektaGateway
      app.config.spree.payment_methods << Spree::BillingIntegration::ConektaGateway::Cash
      app.config.spree.payment_methods << Spree::BillingIntegration::ConektaGateway::Card
      app.config.spree.payment_methods << Spree::BillingIntegration::ConektaGateway::Bank
      app.config.spree.payment_methods << Spree::BillingIntegration::ConektaGateway::MonthlyPayment
    end

    initializer 'spree_conekta.assets.precompile' do |app|
      app.config.assets.precompile += %w( spree/backend/print.css )
    end

    config.to_prepare &method(:activate).to_proc
  end
end
