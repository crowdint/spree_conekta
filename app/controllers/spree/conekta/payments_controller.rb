module Spree::Conekta
  class PaymentsController < ActionController::Base
    def create
      Rails.logger.info params.inspect
      render nothing: true
    end
  end
end
