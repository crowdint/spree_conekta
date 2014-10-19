FactoryGirl.modify do
  factory :order, class: Spree::Order do
    currency 'MXN'
  end
end
