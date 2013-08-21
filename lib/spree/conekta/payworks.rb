module Spree::Conekta
  class Payworks
    def initialize(card)
      @banorte_base = URI(card['redirect_form']['url'])
      @base_uri = @banorte_base.path.split('/')
      @banorte_url = "#{@banorte_base.scheme}://#{@banorte_base.host}/#{@base_uri[1]}"
      @card = card
    end

    def banorte_payment
      payworks_response = request("#{@banorte_url}/#{@base_uri[2]} ", @card['redirect_form']['attributes'])
      url, params = extract_form payworks_response.body

      payworks_payment = request "#{@banorte_url}/#{url}", params, {
        'COOKIE' => payworks_response.headers['Set-Cookie']
      }

      extract_follow payworks_payment.body
    end

    def extract_follow(form)
      url, params = extract_form form
      extract_follow request(url, params).body if url
    end

    def request(url, params, headers = {})
      connection = build_connection
      connection.headers = headers
      connection.post url, params
    end

    def extract_form(page)
      content = parse_body(page)
      post_url = content.css('form').first && content.css('form').first['action']

      post_params = content.css("input").map do |input|
        [input['name'], input['value']]
      end.flatten

      [post_url, Hash[*post_params]]
    end

    def build_connection
      Faraday.new do |f|
        f.use FaradayMiddleware::FollowRedirects
        f.request :url_encoded
        f.response :logger
        f.adapter :typhoeus
      end
    end

    def parse_body(body)
      Nokogiri::HTML(body)
    end
  end
end
