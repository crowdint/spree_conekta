module Spree::Conekta::PaymentSource
  module Cash
    def request(common, method, gateway_options)
      common['cash'] = {
        'type' => 'oxxo'
      }
    end

    module_function :request
  end
end
