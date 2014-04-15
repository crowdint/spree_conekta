module Spree
  module Conekta
    class CreditCardCollection
      include Enumerable
      include Spree::Conekta::Client

      extend  Forwardable

      def_instance_delegators :@cards, :each, :size, :empty?

      attr_reader :customer

      def initialize(customer, options)
        @customer   = customer
        @auth_token = options[:auth_token]
        @cards      = build_cards(get)
      end

      def add(token)
        @cards << Spree::Conekta::CreditCard.create(customer, token, auth_token)
      end

      def endpoint
        "customers/#{customer.id}/cards"
      end

      def reload
        @cards = build_cards(get)
      end

      def find(id)
        super { |credit_card| credit_card.id == id }
      end

      def to_ary
        self
      end

      private

      def build_cards(response)
        response.map do |credit_card|
          Spree::Conekta::CreditCard.build(customer, credit_card, auth_token)
        end
      end
    end
  end
end
