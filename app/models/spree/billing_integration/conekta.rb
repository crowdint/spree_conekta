module Spree
   class BillingIntegration::Conekta < Gateway
     preference :auth_token, :string
     preference :source_method, :string, default: ['card, cash, bank']

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
