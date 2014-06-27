require 'spec_helper'

describe Spree::Conekta::CreditCardsController do
  let!(:user) { create(:user) }
  let(:token) { 'key_R3JNHadccMTdmpzZ' }

  let!(:customer) do
    VCR.use_cassette('card_manager.customer') do
      customer = Spree::Conekta::Customer.new(user, auth_token: token)
      customer.id
      customer
    end
  end

  let!(:credit_card) do
    VCR.use_cassette('card_manager.credit_card') do
      Spree::Conekta::CreditCard.create customer, 'tok_test_visa_4242', token
    end
  end

  before do
    SpreeConekta::Config.private_key = token
    controller.stub spree_current_user: user
  end

  describe 'get :index' do
    before do
      VCR.use_cassette('card_manager.fetch_credit_cards') do
        spree_get :index
      end
    end

    it 'sets the credit_cards variable' do
      expect(assigns(:credit_cards)).to_not be_empty
    end
  end

  describe 'get #edit' do
    before do
      spree_get :new
    end

    it 'sets the credit_card variable' do
      expect(assigns(:credit_card)).to_not be_nil
    end
  end

  describe 'get #edit' do
    before do
      VCR.use_cassette('card_manager.fetch_credit_card') do
        spree_get :edit, id: credit_card.id
      end
    end

    it 'sets the credit_card variable' do
      expect(assigns(:credit_card)).to_not be_nil
    end
  end

  describe 'put #update' do
    before do
      VCR.use_cassette('card_manager.update_credit_card') do
        spree_put :update, id: credit_card.id, conekta_credit_card: { token: 'tok_test_mastercard_4444' }
      end
    end

    it 'sets the credit_card variable' do
      expect(assigns(:credit_card)).to_not be_nil
    end

    specify do
      expect(assigns(:credit_card).last4).to eq '4444'
    end
  end

  describe 'delete #destroy' do
    before do
      VCR.use_cassette('card_manager.delete_credit_card') do
        spree_delete :destroy, id: credit_card.id
      end

      VCR.use_cassette('card_manager.fetch_after_destroy') do
        customer.credit_cards.reload
      end
    end

    specify do
      expect(customer.credit_cards).to be_empty
    end
  end

  describe 'post #create' do
    context 'A valid token' do
      before do
        VCR.use_cassette('card_manager.create_credit_card') do
          spree_post :create, conekta_credit_card: { token: 'tok_test_mastercard_5100' }
        end

        VCR.use_cassette('card_manager.fetch_after_create') do
          customer.credit_cards.reload
        end
      end

      specify do
        expect(customer.credit_cards).to_not be_empty
      end
    end

    context 'An invalid token' do
      before do
        request.env["HTTP_REFERER"] = '/'
        VCR.use_cassette('card_manager.create_credit_card_invalid') do
          spree_post :create, conekta_credit_card: { token: '1234567' }
        end
      end

      specify do
        expect(flash[:error]).to_not be_nil
      end
    end
  end

end
