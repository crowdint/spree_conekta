module Spree
  Payment.class_eval do
    def payment_method_source
      payment_method.options[:source_method]
    end
  end
end



