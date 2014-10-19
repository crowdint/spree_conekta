FactoryGirl.modify do
  factory :line_item, class: Spree::LineItem do
    price { BigDecimal.new('29.00') }
    currency 'MXN'
  end
end

