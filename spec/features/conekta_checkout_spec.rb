require 'spec_helper'
Dir[File.join(File.dirname(__FILE__), "../factories/**/*.rb")].each {|f| require f }

Spree::Config[:currency] = 'MXN'

describe "Conekta checkout" do
  let!(:country) { create(:country, states_required: true) }
  let!(:state) { create(:state, country: country) }
  let!(:shipping_method) { create(:shipping_method) }
  let!(:stock_location) { create(:stock_location) }
  let!(:mug) { create(:product, name: "RoR Mug") }

  let!(:zone) { create(:zone) }

  let!(:order) { OrderWalkthrough.up_to(:delivery) }

  before do
    puts "factory :price amount: #{price.amount} currency: #{price.currency}"

    user = create(:user)

    order.stub :confirmation_required? => true

    order.reload
    order.user = user
    order.currency = 'MXN'
    order.update!


    order.stub total: 2000

    Spree::PaymentMethod.destroy_all

    Spree::CheckoutController.any_instance.stub(current_order: order)
    Spree::CheckoutController.any_instance.stub(try_spree_current_user: user)
    Spree::CheckoutController.any_instance.stub(:skip_state_validation? => true)
  end

  describe "the payment source is credit card", js: true do
    before do
      ENV['CONEKTA_PUBLIC_KEY'] = '1tv5yJp3xnVZ7eK67m4h'
    end

    context 'With a valid card' do
      let!(:conekta_payment) do
        Spree::BillingIntegration::Conekta::Card.create!(
            name: "conekta",
            environment: "test",
            preferred_auth_token: '1tv5yJp3xnVZ7eK67m4h'
        )
      end

      before do
        visit spree.checkout_state_path(:payment)

        fill_in "Card Number", with: "4242 4242 4242 4242"

        page.execute_script("$('.cardNumber').trigger('change')")
        fill_in "Card Code", with: "123"

        select('1', from: 'card_month')
        select(Time.now.year + 1, from: 'card_year')

        page.execute_script("$('#gateway_payment_profile_id').val('tok_test_visa_4242')")

        click_button "Save and Continue"

        sleep(2)

        page.current_url.should include("/checkout/confirm")

        VCR.use_cassette('conekta_card') do
          click_button "Place Order"
        end
      end

      it "can process a valid payment" do
        page.should have_content("Your order has been processed successfully")
      end

      it 'should complete the payment' do
        order.payments.last.state.should eq('completed')
      end

      it 'should not show the conekta order receipt' do
        page.current_url.should_not include("/conekta/payments")
      end
    end

    context 'With an invalid card' do
      let!(:conekta_payment) do
        Spree::BillingIntegration::Conekta::Card.create!(
            name: "conekta",
            environment: "test",
            preferred_auth_token: '1tv5yJp3xnVZ7eK67m4h'
        )
      end

      before do
        visit spree.checkout_state_path(:payment)

        fill_in "Card Number", with: "4000 0000 0000 0002"

        page.execute_script("$('.cardNumber').trigger('change')")
        fill_in "Card Code", with: "123"

        select('1', from: 'card_month')
        select(Time.now.year + 1, from: 'card_year')

        page.execute_script("$('#gateway_payment_profile_id').val('test_tok_card_declined')")

        click_button "Save and Continue"

        sleep(2)

        page.current_url.should include("/checkout/confirm")

        VCR.use_cassette('conekta_invalid_card') do
          click_button "Place Order"
        end
      end

      it "should not process an invalid payment" do
        page.should_not have_content("Your order has been processed successfully")
      end

      it 'should set the payment state as failed' do
        order.payments.last.state.should eq('failed')
      end

      it 'should not show the conekta order receipt' do
        page.current_url.should_not include("/conekta/payments")
      end
    end

    context 'With a card with errors' do
      let!(:conekta_payment) do
        Spree::BillingIntegration::Conekta::Card.create!(
            name: "conekta",
            environment: "test",
            preferred_auth_token: '1tv5yJp3xnVZ7eK67m4h'
        )
      end

      before do
        visit spree.checkout_state_path(:payment)

        fill_in "Card Number", with: "4000 0000 0000 0119"

        page.execute_script("$('.cardNumber').trigger('change')")
        fill_in "Card Code", with: "123"

        select('1', from: 'card_month')
        select(Time.now.year + 1, from: 'card_year')

        page.execute_script("$('#gateway_payment_profile_id').val('test_tok_processing_error')")

        click_button "Save and Continue"

        sleep(2)

        page.current_url.should include("/checkout/confirm")

        VCR.use_cassette('conekta_card_with_errors') do
          click_button "Place Order"
        end
      end

      it "should not process an invalid payment" do
        page.should_not have_content("Your order has been processed successfully")
      end

      it 'should set the payment state as failed' do
        order.payments.last.state.should eq('failed')
      end

      it 'should not show the conekta order receipt' do
        page.current_url.should_not include("/conekta/payments")
      end
    end

    context 'With a card with limit exceeded' do
      let!(:conekta_payment) do
        Spree::BillingIntegration::Conekta::Card.create!(
            name: "conekta",
            environment: "test",
            preferred_auth_token: '1tv5yJp3xnVZ7eK67m4h'
        )
      end

      before do
        visit spree.checkout_state_path(:payment)

        fill_in "Card Number", with: "4000 0000 0000 0127"

        page.execute_script("$('.cardNumber').trigger('change')")
        fill_in "Card Code", with: "123"

        select('1', from: 'card_month')
        select(Time.now.year + 1, from: 'card_year')

        page.execute_script("$('#gateway_payment_profile_id').val('test_tok_limit_exceeded')")

        click_button "Save and Continue"

        sleep(2)

        page.current_url.should include("/checkout/confirm")

        VCR.use_cassette('conekta_limit_exceeded_card') do
          click_button "Place Order"
        end
      end

      it "should not process an invalid payment" do
        page.should_not have_content("Your order has been processed successfully")
      end

      it 'should set the payment state as failed' do
        order.payments.last.state.should eq('failed')
      end

      it 'should not show the conekta order receipt' do
        page.current_url.should_not include("/conekta/payments")
      end
    end
  end

  context "the payment source is cash" do
    let!(:conekta_payment) do
      Spree::BillingIntegration::Conekta::Cash.create!(
        name: "conekta",
        environment: "test",
        preferred_auth_token: '1tv5yJp3xnVZ7eK67m4h'
      )
    end

    before do
      visit spree.checkout_state_path(:payment)

      click_button "Save and Continue"
      sleep(2)

      page.current_url.should include("/checkout/confirm")

      VCR.use_cassette('conekta_cash') do
        click_button "Place Order"
      end
    end

    it "can process a valid payment", js: true do
      page.should have_content("Your order has been processed successfully")
      page.should have_content("OXXO")
    end

    it 'should leave the payment as pending' do
      order.payments.last.state.should eq('pending')
    end

    it 'should show the conekta order receipt with the oxxo barcode' do
      page.current_url.should include("/conekta/payments")
    end
  end

 context "the payment source is bank" do
    let!(:conekta_payment) do
      Spree::BillingIntegration::Conekta::Bank.create!(
        name: "conekta",
        environment: "test",
        preferred_auth_token: '1tv5yJp3xnVZ7eK67m4h'
      )
    end

    before do
      visit spree.checkout_state_path(:payment)

      click_button "Save and Continue"
      sleep(2)

      page.current_url.should include("/checkout/confirm")

      VCR.use_cassette('conekta_bank') do
        click_button "Place Order"
      end
    end

    it "can process a valid payment", js: true do
      page.should have_content("Your order has been processed successfully")
      page.should have_content("Banorte")
    end

    it 'should leave the payment as pending' do
      order.payments.last.state.should eq('pending')
    end

    it 'should show the conekta order receipt' do
      page.current_url.should include("/conekta/payments")
    end
  end
end
