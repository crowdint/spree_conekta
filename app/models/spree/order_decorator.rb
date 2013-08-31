module Spree
  Order.class_eval do
    Spree::Conekta
    Spree::Conekta::Response
    Spree::Conekta::PaymentSource
    Spree::Conekta::PaymentSource::Card

    def last_payment_details
      YAML.load payments.last.log_entries.last.details
    end
  end
end
