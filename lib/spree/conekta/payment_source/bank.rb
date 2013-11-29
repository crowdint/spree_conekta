module Spree::Conekta::PaymentSource
  module Bank
    def request(common, method, gateway_options)
      common['bank'] = {
          'type' => 'banorte'
      }
    end

    module_function :request
  end
end
