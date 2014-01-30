require 'spec_helper'

module Spree
  describe CheckoutController do
    let(:token) { 'some_token' }
    let(:user) { stub_model(Spree::LegacyUser) }
    let(:order) { FactoryGirl.create(:order_with_totals) }

    before do
      controller.stub try_spree_current_user: user
      controller.stub current_order: order
    end
  end
end
