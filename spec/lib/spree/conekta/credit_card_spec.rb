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

  describe '#destroy' do
    before do
      VCR.use_cassette('create_credit_card') do
        @card = described_class.create(customer, 'tok_test_visa_4242', auth_token)
      end
    end

    it 'Removes the credit card from conekta' do
      VCR.use_cassette('destroy_credit_card') do
        expect(@card.destroy).to be_true
      end
    end
  end

  describe '#update' do
    before do
      VCR.use_cassette('create_credit_card_2') do
        @card = described_class.create(customer, 'tok_test_visa_4242', auth_token)
      end
    end

    it 'updates an existent credit card' do
      VCR.use_cassette('update_credit_card') do
        expect{@card.update('tok_test_mastercard_4444')}.to change{@card.last4}.to '4444'
      end
    end
  end

  describe 'persisted?' do
    subject { described_class.new(customer, {}) }

    context 'When id is present' do
      before do
        subject.stub id: 10
      end

      specify { expect(subject.persisted?).to be_true }
    end

    context 'When id is not present' do
      before do
        subject.stub id: nil
      end

      specify { expect(subject.persisted?).to be_false }
    end
  end

  describe '#to_key' do
    subject { described_class.new(customer, {}) }
    before  { subject.stub id: 1 }

    specify { expect(subject.to_key).to eq [1] }
  end

  describe '#to_param' do
    subject { described_class.new(customer, {}) }
    before  { subject.stub id: 1 }

    specify { expect(subject.to_param).to eq 1 }
  end
end
