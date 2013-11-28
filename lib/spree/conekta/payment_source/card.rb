module Spree::Conekta::PaymentSource
  module Card
    def request(common, method)
      common['card'] = {
        'name' => "#{method.first_name} #{method.last_name}",
        'cvc' => method.verification_value,
        'number' => method.number,
        'exp_year' => method.year.to_s[-2,2],
        'exp_month' => sprintf('%02d', method.month),
        'address' => customer_address(common)
      }
    end

    def self.customer_address(common_gateway)
      customer = common_gateway[:billing_address]
      customer['street1'] = customer.delete(:address1)
      customer['street2'] = customer.delete(:address2)
      customer
    end

    module_function :request
  end
end
