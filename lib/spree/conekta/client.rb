module Spree::Conekta
  module Client
    CONEKTA_API = 'https://api.conekta.io/'

    attr_accessor :auth_token, :response_error

    def post(params, raise_exceptions = true)
      parse_response connection.post(endpoint, Oj.dump(params)), raise_exceptions
    end

    def put(id, params, raise_exceptions = true)
      parse_response connection.put("#{endpoint}/#{id}", Oj.dump(params)), raise_exceptions
    end

    def get(raise_exceptions = true)
      parse_response connection.get(endpoint), raise_exceptions
    end

    def delete(id, raise_exceptions = true)
      parse_response connection.delete("#{endpoint}/#{id}"), raise_exceptions
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

    def parse_response(response, raise_exceptions)
      body = Oj.load response.body
      if response.success?
        self.response_error = nil
        body
      else
        self.response_error = body
        Spree::Conekta::Exceptions.create body['type'], body['message'] if raise_exceptions
        body
      end
    end
  end
end
