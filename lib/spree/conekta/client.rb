module Spree::Conekta
  class Client
    CONEKTA_API = 'https://api.conekta.io/'
    CHARGE_ENDPOINT = 'charges.json'

    attr_accessor :auth_token

    PAYMENT_SOURCES = {
        'card' => Spree::Conekta::PaymentSource::Card,
        'bank' => Spree::Conekta::PaymentSource::Bank,
        'cash' => Spree::Conekta::PaymentSource::Cash
    }

    def post(params)
      Oj.load connection.post(CHARGE_ENDPOINT, Oj.dump(params)).body
    end

    def payment_processor(source_name)
      PAYMENT_SOURCES[source_name]
    end

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
          'Accept' => ' application/vnd.conekta-v0.2.0+json',
          'Content-type' => ' application/json',
          'Authorization' => "Basic #{auth_token}:"
      }
    end
  end
end
