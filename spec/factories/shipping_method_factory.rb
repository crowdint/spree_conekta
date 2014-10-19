FactoryGirl.modify do
  factory :base_shipping_method, class: Spree::ShippingMethod do
    after(:create) do |sm| 
      sm.calculator.preferred_amount = 10
      sm.calculator.preferred_currency = "MXN"
      sm.save
    end
  end
end
