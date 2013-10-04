class Spree::ConektaPayment < ActiveRecord::Base
  attr_accessible :payment_type, :first_name, :last_name
  has_many :payments, as: :source

  def actions
    %w{capture}
  end

  def can_capture?(payment)
    ['checkout', 'pending'].include?(payment.state)
  end
end
