module Spree::Conekta
  class CreditCardsController < Spree::StoreController
    ssl_required

    before_filter :find_customer

    def index
      @credit_cards = @customer.credit_cards
    end

    def new; end

    def create
      @customer.add_credit_card(params[:token])
    end

    def destroy
      @customer.delete_credit_card(params[:id])
    end

    private

    def find_customer
      @customer = Spree::Conekta::Customer.new(spree_current_user, auth_token: SpreeConekta::Config.private_key)
    end
  end
end
