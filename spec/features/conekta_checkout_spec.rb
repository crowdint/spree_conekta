require 'spec_helper'
Dir[File.join(File.dirname(__FILE__), "../factories/**/*.rb")].each {|f| require f }

Spree::Config[:currency] = 'MXN'

RSpec.describe "Conekta checkout", type: :feature do
  let!(:country) { create(:country, states_required: true) }
  let!(:state) { create(:state, country: country) }
  let!(:shipping_method) { create(:shipping_method) }
  let!(:stock_location) { create(:stock_location) }
  let!(:mug) { create(:product, name: "RoR Mug") }

  let!(:zone) { create(:zone) }

  let!(:order) { OrderWalkthrough.up_to(:delivery) }

  before do
    user = create(:user)

    allow(order).to receive(:confirmation_required?).and_return(true)

    order.reload
    order.user = user
    order.currency = 'MXN'
    order.update!


    allow(order).to receive(:total).and_return(2000)

    Spree::PaymentMethod.destroy_all

    allow_any_instance_of(Spree::CheckoutController).to receive(:current_order).and_return(order)
    allow_any_instance_of(Spree::CheckoutController).to receive(:try_spree_current_user).and_return(user)
    allow_any_instance_of(Spree::CheckoutController).to receive(:skip_state_validation?).and_return(true)

  end

  describe "the payment source is credit card", js: true do
    before do

      ENV['CONEKTA_PUBLIC_KEY'] = '1tv5yJp3xnVZ7eK67m4h'
    end

    context 'With a valid card' do
      let!(:conekta_payment) do
        Spree::BillingIntegration::ConektaGateway::Card.create!(
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

        expect(page.current_url).to include("/checkout/confirm")

        VCR.use_cassette('conekta_card') do
          click_button "Place Order"
        end
      end

      it "can process a valid payment" do
        expect(page).to have_content("Your order has been processed successfully")
      end

      it 'should complete the payment' do
        expect(order.payments.last.state).to eq('completed')
      end

      it 'should not show the conekta order receipt' do
        expect(page.current_url).to_not include("/conekta/payments")
      end
    end

    context 'With an invalid card' do
      let!(:conekta_payment) do
        Spree::BillingIntegration::ConektaGateway::Card.create!(
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

        expect(page.current_url).to include("/checkout/confirm")

        VCR.use_cassette('conekta_invalid_card') do
          click_button "Place Order"
        end
      end

      it "should not process an invalid payment" do
        expect(page).to_not have_content("Your order has been processed successfully")
      end

      it 'should set the payment state as failed' do
        expect(order.payments.last.state).to eq('failed')
      end

      it 'should not show the conekta order receipt' do
        expect(page.current_url).to_not include("/conekta/payments")
      end
    end

    context 'With a card with errors' do
      let!(:conekta_payment) do
        Spree::BillingIntegration::ConektaGateway::Card.create!(
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

        expect(page.current_url).to include("/checkout/confirm")

        VCR.use_cassette('conekta_card_with_errors') do
          click_button "Place Order"
        end
      end

      it "should not process an invalid payment" do
        expect(page).to_not have_content("Your order has been processed successfully")
      end

      it 'should set the payment state as failed' do
        expect(order.payments.last.state).to eq('failed')
      end

      it 'should not show the conekta order receipt' do
        expect(page.current_url).to_not include("/conekta/payments")
      end
    end

    context 'With a card with limit exceeded' do
      let!(:conekta_payment) do
        Spree::BillingIntegration::ConektaGateway::Card.create!(
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

        expect(page.current_url).to include("/checkout/confirm")

        VCR.use_cassette('conekta_limit_exceeded_card') do
          click_button "Place Order"
        end
      end

      it "should not process an invalid payment" do
        expect(page).to_not have_content("Your order has been processed successfully")
      end

      it 'should set the payment state as failed' do
        expect(order.payments.last.state).to eq('failed')
      end

      it 'should not show the conekta order receipt' do
        expect(page.current_url).to_not include("/conekta/payments")
      end
    end
  end

  context "the payment source is cash", js: true do
    let!(:conekta_payment) do
      Spree::BillingIntegration::ConektaGateway::Cash.create!(
        name: "conekta",
        environment: "test",
        preferred_auth_token: '1tv5yJp3xnVZ7eK67m4h'
      )
    end

    before do
      visit spree.checkout_state_path(:payment)

      click_button "Save and Continue"
      sleep(2)

      expect(page.current_url).to include("/checkout/confirm")

      VCR.use_cassette('conekta_cash') do
        click_button "Place Order"
      end
    end

    it "can process a valid payment", js: true do
      expect(page).to have_content("Your order has been processed successfully")
      expect(page).to have_content("OXXO")
    end

    it 'should leave the payment as pending' do
      expect(order.payments.last.state).to eq('pending')
    end

    it 'should show the conekta order receipt with the oxxo barcode' do
      expect(page.current_url).to include("/conekta/payments")
    end
  end

 context "the payment source is bank", js: true do
    let!(:conekta_payment) do
      Spree::BillingIntegration::ConektaGateway::Bank.create!(
        name: "conekta",
        environment: "test",
        preferred_auth_token: '1tv5yJp3xnVZ7eK67m4h'
      )
    end

    before do
      visit spree.checkout_state_path(:payment)

      click_button "Save and Continue"
      sleep(2)

      expect(page.current_url).to include("/checkout/confirm")

      VCR.use_cassette('conekta_bank') do
        click_button "Place Order"
      end
    end

    it "can process a valid payment", js: true do
      expect(page).to have_content("Your order has been processed successfully")
      expect(page).to have_content("Banorte")
    end

    it 'should leave the payment as pending' do
      expect(order.payments.last.state).to eq('pending')
    end

    it 'should show the conekta order receipt' do
      expect(page.current_url).to include("/conekta/payments")
    end
  end
end
