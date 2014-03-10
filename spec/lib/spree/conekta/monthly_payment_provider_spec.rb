require 'spec_helper'

describe Spree::Conekta::MonthlyPaymentProvider do
  let(:source) { double(Spree::CreditCard) }

  describe '#authorize' do
    context 'An approved transaction' do
      let(:conekta_response) do
        {
            status: '200',
            message: 'OK'
        }.to_json
      end

      before do
        source.stub conekta_response: conekta_response
      end

      specify { expect(subject.authorize(2000, source, {})).to be_success }
    end

    context 'A rejected transaction' do
      let(:conekta_response) do
        {
          type: 'error'
        }.to_json
      end

      before do
        source.stub conekta_response: conekta_response
      end

      specify { expect(subject.authorize(2000, source, {})).to_not be_success }
    end
  end

  describe '#capture' do
    specify { expect(subject.capture(2000, source, {})).to be_a_kind_of Spree::Conekta::Response }
  end
end
