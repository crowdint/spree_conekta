module Spree::Conekta::PaymentSource
  module Bank
    def request(common, method, gateway_options)
      type = gateway_options[:type]
      type ||= 'banorte'
      common['bank'] = {
          'type' => type
      }
    end

    module_function :request
  end
end
