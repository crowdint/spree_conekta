module Spree::Conekta
  class PaymentsController < Spree::StoreController
    ssl_required

    def show
      @order = Spree::Order.find_by_number(params[:id])
      @order_details = @order.last_payment_details.params
    end

    def create
      update_order_payment if params['type'].eql? 'charge.paid'
      render nothing: true
    end

    private
    def update_order_payment
      Spree::Payment.capture_by_order_number params['data']['object']['reference_id']
    end
  end
end
