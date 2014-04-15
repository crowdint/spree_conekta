module Spree::Conekta
  class CreditCardsController < Spree::StoreController
    ssl_required

    before_filter :find_customer
    before_filter :find_credit_card, only: [:edit, :update, :destroy]

    def index
      @credit_cards = @customer.credit_cards
    end

    def new
      @credit_card = Spree::Conekta::CreditCard.new @customer, auth_token: SpreeConekta::Config.private_key
    end

    def create
      @customer.add_credit_card(params[:conekta_credit_card][:token])
      redirect_to conekta_credit_cards_path
    end

    def edit; end

    def update
      @credit_card.update(params[:conekta_credit_card][:token])
      redirect_to conekta_credit_cards_path
    end

    def destroy
      @credit_card.destroy
      redirect_to conekta_credit_cards_path
    end

    private

    def find_customer
      @customer = Spree::Conekta::Customer.new(spree_current_user, auth_token: SpreeConekta::Config.private_key)
    end

    def find_credit_card
      @credit_card = @customer.credit_cards.find(params[:id])
    end
  end
end
