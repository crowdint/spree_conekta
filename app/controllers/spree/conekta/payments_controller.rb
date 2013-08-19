module Spree::Conekta
  class PaymentsController < ActionController::Base
    def create
      update_order_payment if params['type'].eql? 'charge.paid'
      render nothing: true
    end

    private
    def update_order_payment
      #TODO: we need to figure out how implement an ACL list for this method
      order_number = params['data']['object']['reference_id'].split('-')[0]
      order = Spree::Order.by_number(order_number).first
      order.payments.first.capture!
    end
  end
end
