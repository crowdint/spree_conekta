module Spree::Conekta
  class Provider
    include Spree::Conekta::Client

    attr_accessor :auth_token, :source_method

    PAYMENT_SOURCES = {
        'card' => Spree::Conekta::PaymentSource::Card,
        'bank' => Spree::Conekta::PaymentSource::Bank,
        'cash' => Spree::Conekta::PaymentSource::Cash
    }

    def initialize(options = {})
      self.auth_token = options[:auth_token]
      self.source_method = payment_processor(options[:source_method])
    end

    def authorize(amount, method_params, gateway_options = {})
      common = build_common(amount, gateway_options)
      commit common, method_params, gateway_options
    end

    alias_method :purchase, :authorize

    def capture(amount, method_params, gateway_options = {})
      Response.new({}, gateway_options)
    end

    def endpoint
      'charges'
    end

    def payment_processor(source_name)
      PAYMENT_SOURCES[source_name]
    end

    private

    def commit(common, method_params, gateway_options)
      source_method.request(common, method_params, gateway_options)
      Spree::Conekta::Response.new post(common), source_method
    end

    def build_common(amount, gateway_params)
      if source_method == Spree::Conekta::PaymentSource::Cash && gateway_params[:currency] != 'MXN'
        return build_common_to_cash(amount, gateway_params) 
      else
        {
          'amount' => amount,
          'reference_id' => gateway_params[:order_id],
          'currency' => gateway_params[:currency],
          'description' => gateway_params[:order_id]
        }
      end
    end
    
    def build_common_to_cash(amount, gateway_params)
      amount_exchanged = Spree::Conekta::Exchange.new(amount, gateway_params[:currency]).amount_exchanged
      {
        'amount' => amount_exchanged,
        'reference_id' => gateway_params[:order_id],
        'currency' => "MXN",
        'description' => gateway_params[:order_id]
      }
    end
  end
end
