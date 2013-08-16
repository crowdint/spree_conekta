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

      puts common
    end

    def parse(response)
      complete_3d_secure response['card']
      ActiveMerchant::Billing::Response.new 'completed', 'charge'
    end

    def complete_3d_secure(card)
      Faraday.new { |f| f.use FaradayMiddleware::FollowRedirects }.post card['redirect_form']['url'],
                                                                        card['redirect_form']['attributes']
    end

    module_function :request, :parse
  end
end

