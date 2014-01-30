module Spree
  CheckoutController.class_eval do
    def completion_route
      if @order.payments.present? && conekta_payment?(@order.payments.last)
         conekta_payment_path(@order)
      else
        spree.order_path(@order)
      end
    end

    private

    def conekta_payment?(payment_method)
        [Spree::BillingIntegration::Conekta::Bank, Spree::BillingIntegration::Conekta::Cash].include? payment_method.class
    end
  end
end
