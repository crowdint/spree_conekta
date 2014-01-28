module Spree
  module Conekta
    class CreditCard
      include Spree::Conekta::Client

      attr_reader   :customer
      attr_accessor :id, :brand, :last4

      def self.create(customer, token, auth_token)
        new(customer, token: token, auth_token: auth_token)
      end

      def self.build(customer, card, auth_token)
        new(customer, card: card, auth_token: auth_token)
      end

      def initialize(customer, options)
        @customer   = customer
        @auth_token = options[:auth_token]
        build_card(options[:card])   if options[:card]
        create_card(options[:token]) if options[:token]
      end

      def endpoint
        "customers/#{customer.id}/cards"
      end

      private

      def build_card(card)
        @id    = card['id']
        @brand = card['brand']
        @last4 = card['last4']
      end

      def create_card(token)
        response = post(token: token)
        build_card(response)
      end
    end
  end
end
