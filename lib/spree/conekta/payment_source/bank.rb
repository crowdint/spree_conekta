module Spree::Conekta::PaymentSource
  module Bank
    def request(common, method)
      common['bank'] = {
          'type' => 'banorte'
      }
    end

    def parse(response)
      Spree::Conekta::Response.new response, self
    end

    module_function :request, :parse
  end
end
