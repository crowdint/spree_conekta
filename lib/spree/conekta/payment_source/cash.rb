module Spree::Conekta::PaymentSource
  module Cash
    def request(common, method)
      common['cash'] = {
        'type' => 'oxxo'
      }
    end

    module_function :request
  end
end
