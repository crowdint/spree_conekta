module Spree
  module Conekta
    class Customer
      include Spree::Conekta::Client

      attr_reader :user, :options, :credit_cards

      def initialize(user, options = {})
        @user         = user
        @options      = options
        @auth_token   = options[:auth_token]
      end

      def id
        @id ||= user.gateway_customer_profile_id || create_new_client
      end

      def add_credit_card(token)
        credit_cards.add(token)
      end

      def credit_cards
        @credit_cards ||= Spree::Conekta::CreditCardCollection.new(self, auth_token: auth_token)
      end

      def endpoint
        'customers'
      end

      private

      def create_new_client
        response = post(name: user.email, email: user.email)
        user.update_column(:gateway_customer_profile_id, response['id']) if options[:persist]
        response['id']
      end
    end
  end
end
