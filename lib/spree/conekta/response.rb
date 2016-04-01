module Spree::Conekta
  class Response < ActiveMerchant::Billing::Response
    attr_accessor :response, :source_method, :status

    def initialize(response, source_method)
      @success = !(response.eql?('null') || response.include?('type')) if response
      @message = @success ? 'Ok' : response['message']
      @params = response
      @params['message'] = @success ? 'Ok' : response['message_to_purchaser']
      @status = response['status']
      @source_method = source_method
    end
  end
end
