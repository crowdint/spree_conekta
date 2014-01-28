require 'spec_helper'

describe Spree::Conekta::CreditCard do
  let(:customer) { double('customer', id: 'cus_e7inii51RjUPsMbP8') }
  let(:auth_token) { '1tv5yJp3xnVZ7eK67m4h' }

  context 'A new credit card' do
    it 'creates a new card' do
      VCR.use_cassette('create_credit_card') do
        @card = described_class.create(customer, 'tok_test_visa_4242', auth_token)
      end
      expect(@card.id).to_not be_nil
    end
  end

  context 'An existent credit card' do
    let(:card) { { 'id' => 1, 'brand' => 'VISA', 'last4' => '4242' } }

    it 'builds a credit card' do
      @card = described_class.build(customer, card, auth_token)
      expect(@card.id).to eq 1
      expect(@card.brand).to eq 'VISA'
      expect(@card.last4).to eq '4242'
    end
  end

  describe '#endpoint' do
    subject { described_class.new(customer, {}) }

    specify { expect(subject.endpoint).to eq('customers/cus_e7inii51RjUPsMbP8/cards') }
  end
end
