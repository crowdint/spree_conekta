module Spree::Conekta
  class Client
    CONEKTA_API = 'https://api.conekta.io/'
    CHARGE_ENDPOINT = 'charges.json'

    PAYMENT_SOURCES = {
        'card' => Spree::Conekta::PaymentSource::Card,
        'bank' => Spree::Conekta::PaymentSource::Bank,
        'cash' => Spree::Conekta::PaymentSource::Cash
    }

    attr_accessor :auth_token

    def connection
      Faraday.new(:url => CONEKTA_API) do |faraday|
        faraday.request :url_encoded
        faraday.response :logger
        faraday.headers = headers
        faraday.adapter :typhoeus
      end
    end

    def headers
      {
          'Accept' => ' application/vnd.example.v1',
          'Content-type' => ' application/json',
          'Authorization' => "Token token=\"#{auth_token}\""
      }
    end

    def post(params)
    Oj.load connection.post(CHARGE_ENDPOINT, Oj.dump(params)).body
    end

    def payment_processor(source_name)
      PAYMENT_SOURCES[source_name]
    end
  end
end
