Spree::CreditCard.class_eval do
  attr_accessor :name_on_card

  unless Rails::VERSION::MAJOR == 4
    attr_accessible :name_on_card, :installments_number
  end

  def name?
    !!name_on_card | (first_name? & last_name?)
  end

  def name
    name_on_card || "#{first_name} #{last_name}"
  end
end
