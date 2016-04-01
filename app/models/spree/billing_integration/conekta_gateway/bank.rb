module Spree
  class BillingIntegration::ConektaGateway::Bank < Gateway
    preference :auth_token, :string
    preference :source_method, :string, default: 'banorte'

    unless Rails::VERSION::MAJOR == 4
      attr_accessible :preferred_auth_token, :preferred_source_method, :gateway_response
    end

    def provider_class
      Spree::Conekta::Provider
    end

    def payment_source_class
      Spree::ConektaPayment
    end

    def method_type
      'conekta'
    end

    def card?
      false
    end

    def auto_capture?
      false
    end
  end
end
