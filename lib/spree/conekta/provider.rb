module Spree::Conekta
  class Provider < Client
    attr_accessor :auth_token, :source_method

    def initialize(options = {})
      self.auth_token = options[:auth_token]
      self.source_method = self.payment_processor(options[:source_method])
    end

    def authorize(amount, method_params, gateway_options = {})
      common = build_common amount, gateway_options
      commit common, method_params
    end

    private
    def commit(common, method_params)
      source_method.request(common, method_params)
      source_method.parse(post(common))
    end

    def build_common(amount, gateway_params)
      charge = {
        'amount' => amount,
        'currency' => gateway_params[:currency],
        'description' => gateway_params[:order_id]
      }

      add_customer(charge, gateway_params)
    end

    def add_customer(charge, gateway_options)
      customer = gateway_options[:billing_address]
      customer['street1'] = customer.delete(:address1)
      customer['street2'] = customer.delete(:address2)

      charge['customer'] = customer
      charge
    end
  end
end
