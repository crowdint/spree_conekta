class Spree::ConektaPayment < ActiveRecord::Base
  belongs_to :payment_method
  has_many :payments, as: :source

  unless Rails::VERSION::MAJOR == 4
    attr_accessible :payment_method_id, :payment_type, :first_name, :last_name, :user_id
  else
    attr_accessor :payment_method_id, :payment_type, :first_name, :last_name, :user_id
  end

  def actions
    %w{capture}
  end

  def can_capture?(payment)
    ['checkout', 'pending'].include?(payment.state)
  end
end
