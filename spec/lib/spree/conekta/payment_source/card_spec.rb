require 'spec_helper'

describe Spree::Conekta::PaymentSource::Card do

  let(:method) do
    double(Spree::CreditCard, gateway_payment_profile_id: '12345', installments_number: 6)
  end

  let(:common){{}}

  describe '#request' do
    it 'adds card token to the common payload' do
      subject.request(common, method, {})
      expect(common['card']).to eq '12345'
    end
  end

  describe '#installments_number' do
    it 'only accepts 6 and 12 as installments number' do
      expect(subject.installments_number(double('source', installments_number: 6))).to eq 6
      expect(subject.installments_number(double('source', installments_number: 12))).to eq 12
      expect(subject.installments_number(double('source', installments_number: 2))).to be_nil
    end
  end
end
