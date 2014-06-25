FactoryGirl.modify do
  factory :base_product, class: Spree::Product do
    cost_currency 'MXN'
  end
end
