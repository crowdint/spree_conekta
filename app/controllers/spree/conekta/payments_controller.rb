module Spree::Conekta
  class PaymentsController < Spree::StoreController
    ssl_required

    def show
      @order = Spree::Order.find_by_number(params[:id])
      @order_details = @order.last_payment_details.params
    end

    def create
      PaymentNotificationHandler.new(params).perform_action unless params['type'] == 'charge.created'
      render nothing: true
    end
  end
end
