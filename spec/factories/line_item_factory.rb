FactoryGirl.modify do
  factory :line_item, class: Spree::LineItem do
    quantity 1
    price { BigDecimal.new('29.00') }
    order
    variant
    currency 'MXN'
  end
end

