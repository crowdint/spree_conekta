module Spree::Conekta::PaymentSource
  module Cash
    def request(common, method)
      common['cash'] = {
        'type' => 'oxxo'
      }
    end

    def parse(response)
      Spree::Conekta::Response.new response, self
    end

    module_function :request, :parse
  end
end
