require 'spec_helper'

describe Spree::Conekta::CreditCardCollection do
  let(:customer) { double('customer', id: 'cus_e7inii51RjUPsMbP8') }
  let(:auth_token) { '1tv5yJp3xnVZ7eK67m4h' }

  subject do
    VCR.use_cassette('laod_card_collection') do
      described_class.new(customer, auth_token: auth_token)
    end
  end

  describe '#add' do
    it 'adds a credit card' do
      VCR.use_cassette('add_a_credit_card') do
        expect{subject.add('tok_test_visa_4242')}.to change{subject.size}.by(1)
      end
    end
  end

  describe '#endpoint' do
    specify { expect(subject.endpoint).to eq('customers/cus_e7inii51RjUPsMbP8/cards') }
  end

  describe '#reload' do
    before do
      subject.stub get: double('response')
      subject.stub build_cards: [double(Spree::Conekta::CreditCard)]
    end

    specify { expect{subject.reload}.to change{subject.size}.to(1) }
  end

  describe '#find' do
    it 'finds a credit card by id' do
      expect(subject.find('card_pSwoseKzEwBr9SDM')).to be_a_kind_of Spree::Conekta::CreditCard
      expect(subject.find('card_Ph6kuMK2dL3QWJAc')).to be_a_kind_of Spree::Conekta::CreditCard
    end
  end
end
