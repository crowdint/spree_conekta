module Spree::Conekta
  module Client
    CONEKTA_API = 'https://api.conekta.io/'

    attr_accessor :auth_token

    def post(params)
      Oj.load connection.post(endpoint, Oj.dump(params)).body
    end

    def get
      Oj.load connection.get(endpoint).body
    end

    def connection
      Faraday.new(url: CONEKTA_API) do |faraday|
        faraday.request :url_encoded

        faraday.headers = headers
        faraday.adapter :typhoeus
        faraday.basic_auth(auth_token, nil)
      end
    end

    def headers
      {
        'Accept' => ' application/vnd.conekta-v0.3.0+json',
        'Content-type' => ' application/json'
      }
    end

    def endpoint
      raise 'Not Implemented'
    end
  end
end
