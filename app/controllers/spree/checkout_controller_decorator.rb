module Spree
  CheckoutController.class_eval do
    def completion_route
      payment_method = @order.payments.last.payment_method
      if payment_method.class == Spree::BillingIntegration::Conekta || !payment_method.preferred_source_method == 'card'
        conekta_payment_path(@order)
      else
        @order.payments.last.complete if payment_method.preferred_source_method == 'card'
        spree.order_path(@order)
      end
    end
  end
end
