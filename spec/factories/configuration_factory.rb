FactoryGirl.modify do
  factory :configuration, class: Spree::Configuration do
    name 'Default Configuration'
    type 'app_configuration'
    currency 'MXN'
  end
end
