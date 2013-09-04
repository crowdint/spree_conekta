class Spree::ConektaPayment < ActiveRecord::Base
  attr_accessible :payment_type, :first_name, :last_name
  has_many :payments, as: :source
end
