module Spree::Conekta
  class Provider < Client
    attr_accessor :auth_token, :source_method

    def initialize(options = {})
      self.auth_token = options[:auth_token]
      self.source_method = payment_processor(options[:source_method])
    end

    def authorize(amount, method_params, gateway_options = {})
      common = build_common(amount, gateway_options)
      commit common, method_params, gateway_options
    end

    def capture(amount, method_params, gateway_options = {})
      Response.new({}, gateway_options)
    end

    private
    def commit(common, method_params, gateway_options)
      source_method.request(common, method_params, gateway_options)
      Spree::Conekta::Response.new post(common), source_method
    end

    def build_common(amount, gateway_params)
      {
        'amount' => amount,
        'reference_id' => gateway_params[:order_id],
        'currency' => gateway_params[:currency],
        'description' => gateway_params[:order_id]
      }
    end
  end
end
