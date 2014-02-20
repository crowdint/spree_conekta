class AddInstallmentsToSpreeCreditCard < ActiveRecord::Migration
  def change
    add_column :spree_credit_cards, :installments_number, :integer
  end
end
