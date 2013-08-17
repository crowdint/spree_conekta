module Spree::Conekta
  class Response < ActiveMerchant::Billing::Response
    attr_accessor :response, :source_method

    def initialize(response, source_method)
      @success = !(response.eql?('null') || response.include?('type'))
      @message = @success ? 'Ok' : response['message']
      @params = response
      @source_method = source_method
    end

  end
end
