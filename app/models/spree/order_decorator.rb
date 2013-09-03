module Spree
  Order.class_eval do
    #HACK
    Spree::Conekta
    Spree::Conekta::Response
    Spree::Conekta::PaymentSource
    Spree::Conekta::PaymentSource::Card

    def last_payment_details
      YAML.load payments.last.log_entries.last.details
    end
    
    def last_payment_source
      payments.last.payment_method_source
    end
  end
end
