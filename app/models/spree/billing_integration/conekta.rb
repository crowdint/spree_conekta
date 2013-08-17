module Spree
  class BillingIntegration::Conekta < Gateway
    preference :auth_token, :string
    preference :source_method, :string, default: 'card'

    attr_accessible :preferred_auth_token, :preferred_source_method

    def provider_class
      Spree::Conekta::Provider
    end
  end
end
