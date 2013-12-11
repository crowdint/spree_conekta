class Spree::ConektaPayment < ActiveRecord::Base
  has_many :payments, as: :source

  unless Rails::VERSION::MAJOR == 4
    attr_accessible :payment_type, :first_name, :last_name
  end

  def actions
    %w{capture}
  end

  def can_capture?(payment)
    ['checkout', 'pending'].include?(payment.state)
  end
end
