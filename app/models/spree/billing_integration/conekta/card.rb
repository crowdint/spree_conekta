module Spree
  class BillingIntegration::Conekta::Card < Gateway
    preference :auth_token, :string
    preference :source_method, :string, default: 'card'
    preference :installments, :boolean, default: false

    unless Rails::VERSION::MAJOR == 4
      attr_accessible :preferred_auth_token, :preferred_source_method, :gateway_response, :preferred_installments
    end

    def provider_class
      Spree::Conekta::Provider
    end

    def payment_source_class
      CreditCard
    end

    def card?
      true
    end

    def auto_capture?
      true
    end

    def with_installments?
      preferred_installments
    end

    def method_type
      'conekta_card'
    end
  end
end
