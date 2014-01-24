module Spree
  CheckoutController.class_eval do
    def completion_route
      payment_method = @order.payments.last.payment_method
      if [Spree::BillingIntegration::Conekta::Bank, Spree::BillingIntegration::Conekta::Cash].include? payment_method.class
        conekta_payment_path(@order)
      else
        spree.order_path(@order)
      end
    end
  end
end
