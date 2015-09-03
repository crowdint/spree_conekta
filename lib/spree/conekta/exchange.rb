module Spree::Conekta
  class Exchange
    
    EXCHANCE_SERVICES = 'https://currency-api.appspot.com/api/'
    
    def initialize(amount, currency_from)
      @amount = (amount.to_i)
      @currency_from = currency_from
      get_exchange_rate
    end
    
    def amount_exchanged
      @amount_exchanged ||= (@amount * @exchange_rate).round
    end
    
    private
    
    def get_exchange_rate
      response = JSON.parse(connection.get("#{@currency_from}/MXN.json?amount=#{@amount}").body)
      @exchange_rate = response['rate'].nil? ? 0 : response['rate'].to_f
    end
    
    def connection
      Faraday.new(url: EXCHANCE_SERVICES) do |faraday|
        faraday.request :url_encoded
        faraday.adapter :typhoeus
      end
    end
  end
end
