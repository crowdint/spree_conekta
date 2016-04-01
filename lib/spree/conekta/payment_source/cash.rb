module Spree::Conekta::PaymentSource
  module Cash
    def request(common, method, gateway_options)
      type = gateway_options[:type]
      type ||= 'oxxo'
      common['cash'] = {
        'type' => type
      }
    end

    module_function :request
  end
end
