module Spree::Conekta
  module Client
    CONEKTA_API = 'https://api.conekta.io/'

    attr_accessor :auth_token, :response_error

    def post(params)
      parse_response connection.post(endpoint, Oj.dump(params))
    end

    def put(id, params)
      parse_response connection.put("#{endpoint}/#{id}", Oj.dump(params))
    end

    def get
      parse_response connection.get(endpoint)
    end

    def delete(id)
      parse_response connection.delete("#{endpoint}/#{id}")
    end

    def response_error?
      !!response_error
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

    private

    def parse_response(response)
      body = Oj.load response.body
      response.success? ? response_error = nil : response_error = body
      body
    end
  end
end
