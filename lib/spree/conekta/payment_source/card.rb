module Spree::Conekta::PaymentSource
  module Card
    def request(common, method)
      common['card'] = {
          'name' => "#{method.first_name} #{method.last_name}",
          'cvc' => method.verification_value,
          'number' => method.number,
          'exp_year' => method.year.to_s[-2,2],
          'exp_month' => sprintf('%02d', method.month)
      }
    end

    def parse(response)
      engine_response =  Spree::Conekta::Response.new response, self
      complete_3d_secure(response['card']) if engine_response.success?
      engine_response
    end

    def complete_3d_secure(card)
      payworks = Spree::Conekta::Payworks.new card
      payworks.banorte_payment
    end

    module_function :request, :parse, :complete_3d_secure
  end
end
