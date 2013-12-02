class Spree::ConektaPayment < ActiveRecord::Base
  has_many :payments, as: :source

  def actions
    %w{capture}
  end

  def can_capture?(payment)
    ['checkout', 'pending'].include?(payment.state)
  end
end
