module Spree
  CheckoutController.class_eval do
    if Rails::VERSION::MAJOR >= 4
      before_action :permit_installments_number
      before_action :permit_conekta_response
    end

    def completion_route
      if @order.payments.present? && conekta_payment?(@order.payments.last.payment_method)
         conekta_payment_path(@order)
      else
        spree.order_path(@order)
      end
    end

    private

    def conekta_payment?(payment_method)
        [Spree::BillingIntegration::ConektaGateway::Bank, Spree::BillingIntegration::ConektaGateway::Cash].include? payment_method.class
    end

    def permit_installments_number
      permitted_source_attributes << :installments_number
    end

    def permit_conekta_response
      permitted_source_attributes << :conekta_response
    end
  end
end
