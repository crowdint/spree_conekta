require 'spec_helper'

describe Spree::Conekta::PaymentSource::Card do

  let(:method) do
    double(Spree::CreditCard, gateway_payment_profile_id: '12345')
  end

  let(:common){{}}

  describe '#request' do
    it 'adds card token to the common payload' do
      subject.request(common, method, {})
      expect(common['card']).to eq '12345'
    end
  end
end
