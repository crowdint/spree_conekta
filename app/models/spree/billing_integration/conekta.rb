module Spree
  class BillingIntegration::Conekta < Gateway
    preference :auth_token, :string
    preference :source_method, :string, default: ['card, cash, bank']

    attr_accessible :preferred_auth_token, :preferred_source_method, :gateway_response

    def provider_class
      Spree::Conekta::Provider
    end
  end
end
