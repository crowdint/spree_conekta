Spree::CreditCard.class_eval do
  attr_accessor :name
  unless Rails::VERSION::MAJOR == 4
    attr_accessible :name
  end
end
