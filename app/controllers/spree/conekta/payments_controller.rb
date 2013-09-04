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
      order_number = params['data']['object']['reference_id'].split('-')[0]
      find_payment(order_number).try(:capture!)
    end

    def find_payment(order_id)
      Spree::Payment.joins(:order)
        .where(state: 'pending',
               spree_orders: { number: order_id })
        .readonly(false).first
    end
  end
end
