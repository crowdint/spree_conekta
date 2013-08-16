module Spree
  class BillingIntegration::Conekta < Gateway
    preference :auth_token, :string
    preference :source_method, :string, default: 'card'

    attr_accessible :preferred_auth_token, :preferred_source_method

    def provider_class
      Spree::Conekta::Provider
    end

    def authorize(money, credit_card, options = {})
      debugger
      provider.authorize(money, credit_card, options)
    end

  end
end
