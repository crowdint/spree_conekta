class AddGatewayCustomerProfileIdToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :gateway_customer_profile_id, :integer
  end
end
