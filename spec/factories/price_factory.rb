FactoryGirl.modify do
  puts "factory :price"
  factory :price, class: Spree::Price do
    variant
    amount 29.99
    currency 'MXN'
  end
end
