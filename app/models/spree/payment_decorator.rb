module Spree
  Payment.class_eval do
    def payment_method_source
      payment_method.options[:source_method]
    end

    def self.find_by_order_number(order_number)
      Spree::Payment.joins(:order)
        .where(state: 'pending', spree_orders: {
          number: order_number
        }).readonly(false).last
    end

    def self.capture_by_order_number(order_number)
      Spree::Payment.find_by_order_number(order_number.split('-')[0]).try(:capture!)
    end
  end
end
