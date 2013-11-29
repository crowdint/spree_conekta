require 'spec_helper'

describe "Conekta checkout" do
  let!(:country) { create(:country, :states_required => true) }
  let!(:state) { create(:state, :country => country) }
  let!(:shipping_method) { create(:shipping_method) }
  let!(:stock_location) { create(:stock_location) }
  let!(:mug) { create(:product, :name => "RoR Mug") }

  let!(:conekta_payment) do
    Spree::BillingIntegration::Conekta.create!(
      :name => "conekta",
      :environment => "test",
      :preferred_source_method => 'card',
      :preferred_auth_token => '1tv5yJp3xnVZ7eK67m4h'
    )
  end

  let!(:zone) { create(:zone) }

  before do
    user = create(:user)

    order = OrderWalkthrough.up_to(:delivery)
    order.stub :confirmation_required? => true

    order.reload
    order.user = user
    order.update!

    Spree::CheckoutController.any_instance.stub(:current_order => order)
    Spree::CheckoutController.any_instance.stub(:try_spree_current_user => user)
    Spree::CheckoutController.any_instance.stub(:skip_state_validation? => true)

    visit spree.checkout_state_path(:payment)
    sleep(2)
  end

  it "can process a valid payment (with JS)", :js => true do
    fill_in "Card Number", :with => "4242 4242 4242 4242"
    # Otherwise ccType field does not get updated correctly
    page.execute_script("$('.cardNumber').trigger('change')")
    fill_in "Card Code", :with => "123"
    fill_in "Expiration", :with => "01 / #{Time.now.year + 1}"
    click_button "Save and Continue"
    sleep(5) # Wait for Stripe API to return + form to submit
    page.current_url.should include("/checkout/confirm")
    click_button "Place Order"
    page.should have_content("Your order has been processed successfully")
  end
end
