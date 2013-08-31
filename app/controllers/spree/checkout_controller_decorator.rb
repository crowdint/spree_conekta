module Spree
  CheckoutController.class_eval do
    def completion_route
      @order.payments.last.payment_method.class == Spree::BillingIntegration::Conekta ? conekta_payment_path(@order) : spree.order_path(@order)
    end
  end
end
