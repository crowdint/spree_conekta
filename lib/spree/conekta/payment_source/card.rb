module Spree::Conekta::PaymentSource
  module Card
    def request(common, method, gateway_options)
      common['card'] = method.gateway_payment_profile_id
    end

    def self.customer_address(gateway_options)
      customer = gateway_options[:billing_address]
      customer['street1'] = customer.delete(:address1)
      customer['street2'] = customer.delete(:address2)
      customer
    end

    module_function :request
  end
end
