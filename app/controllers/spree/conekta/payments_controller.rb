module Spree::Conekta
  class PaymentsController
    def create
      Rails.logger.info params.inspect
      render nothing: true
    end
  end
end
