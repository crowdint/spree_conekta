class AddPaymentMethodIdToSpreeConektaPayment < ActiveRecord::Migration
  def change
    add_column :spree_conekta_payments, :payment_method_id, :integer
    add_index :spree_conekta_payments, :payment_method_id
  end
end
