module Spree::Conekta::PaymentSource
  module Card
    def request(common, method, gateway_options)
      common['card'] = {
        'name' => "#{method.first_name} #{method.last_name}",
        'cvc' => method.verification_value,
        'number' => method.number,
        'exp_year' => method.year.to_s[-2,2],
        'exp_month' => sprintf('%02d', method.month),
        'address' => customer_address(gateway_options)
      }
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
