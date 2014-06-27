class ChangeGatewayCustomerProfileIdToString < ActiveRecord::Migration
  def change
    change_column :spree_users, :gateway_customer_profile_id, :string
  end
end
