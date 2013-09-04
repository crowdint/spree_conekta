module Spree
   class BillingIntegration::Conekta < Gateway
     preference :auth_token, :string
     preference :source_method, :string, default: ['card, cash, bank']

     attr_accessible :preferred_auth_token, :preferred_source_method, :gateway_response

     def provider_class
       Spree::Conekta::Provider
     end

     def payment_source_class
       card? ? CreditCard : Spree::ConektaPayment
     end

     def method_type
       card? ? 'gateway' : 'conekta'
     end

     def card?
       preferred_source_method.eql?('card')
     end

   end
end
