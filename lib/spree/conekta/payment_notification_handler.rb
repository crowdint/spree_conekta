require 'celluloid'

module Spree
  module Conekta
    class PaymentNotificationHandler
      include Celluloid

      attr_reader :params, :action, :order, :delay

      ACTIONS = Hash.new(:failure!).merge! 'charge.paid' => :capture!

      def initialize(params, delay = 30)
        @params = params
        @delay  = delay
        @action = ACTIONS[params['type']]
        @order  = params['data']['object']['reference_id'].split('-').first
      end

      def perform_action
        after(delay) { payment.send(action) }
      end

      private

      def payment
        Spree::Payment.find_by_order_number(order)
      end
    end
  end
end
