module Spree::Conekta::PaymentSource
  module Card
    def request(common, method, gateway_options)
      common['card'] = method.gateway_payment_profile_id
      common['monthly_installments'] = installments_number(method)
    end

    def self.customer_address(gateway_options)
      customer = gateway_options[:billing_address]
      customer['street1'] = customer.delete(:address1)
      customer['street2'] = customer.delete(:address2)
      customer
    end

    def installments_number(source)
      [3,6,9,12].include?(source.installments_number) ? source.installments_number : nil
    end

    module_function :request, :installments_number
  end
end
