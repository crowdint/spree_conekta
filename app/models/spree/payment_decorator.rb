module Spree
  Payment.class_eval do
    def payment_method_source
      payment_method.options[:source_method]
    end

    def self.find_by_payment_id(order_id)
      Spree::Payment.joins(:order)
        .where(state: 'pending', spree_orders: {
          number: order_id
        }).readonly(false).first
    end
  end
end
