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
      #TODO Reauthorize!!!

      banorte_base = URI(card['redirect_form']['url'])
      url_top_namespace = banorte_base.path.split('/')

      connection  = Faraday.new(url: "#{banorte_base.scheme}://#{banorte_base.host}/#{url_top_namespace[1]}") do |faraday|
        faraday.request :url_encoded
        faraday.response :logger
        faraday.adapter :typhoeus
      end

      banorte_registration = connection.post(url_top_namespace[2], card['redirect_form']['attributes'])
      banorte_confirmation = Nokogiri::HTML(banorte_registration.body).css('form').first['action']

      connection.headers['COOKIE'] = banorte_registration.headers['Set-Cookie']
      banorte_confirm = Nokogiri::HTML(connection.post(banorte_confirmation, { 'JavascriptEnabled' => 'NO'}).body)

      conekta_requst = {}
      conekta_url = banorte_confirm.css('form').first['action']

      banorte_confirm.css("input").each do |input|
        conekta_requst[input['name']] = input['value']
      end

      conekta_connection = Faraday.new do |f|
        f.use FaradayMiddleware::FollowRedirects
        f.request :url_encoded
        f.response :logger
        f.adapter :typhoeus
      end

      conekta_connection.post conekta_url, conekta_requst
    end

    module_function :request, :parse, :complete_3d_secure
  end
end

