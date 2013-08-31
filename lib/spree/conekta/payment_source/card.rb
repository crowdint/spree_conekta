module Spree::Conekta::PaymentSource
  module Card
    def request(common, method)
      common['card'] = {
          'name' => "#{method.first_name} #{method.last_name}",
          'cvc' => method.verification_value,
          'number' => method.number,
          'exp_year' => method.year.to_s[-2,2],
          'exp_month' => sprintf('%02d', method.month)
      }
    end

    def parse(response)
      Spree::Conekta::Response.new response, self
    end

    module_function :request, :parse
  end
end
