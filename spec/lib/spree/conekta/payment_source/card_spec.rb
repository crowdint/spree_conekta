require 'spec_helper'

describe Spree::Conekta::PaymentSource::Card do

  let(:method) do
    mock_model(Spree::BillingIntegration::Conekta, {
      first_name: 'test',
      last_name: 'last name test',
      verification_value: '123',
      number:'1111111111111111',
      year:'2018',
      month: '02'
    })
  end

  let(:options) do
    {
      billing_address:
      {
        address1: 'test',
        address2: 'test2 test',
        test_param:  'test 3'
      }
    }
  end

  let(:common){{}}

  describe '.parse' do
    it { expect(subject.request(common, method, options)).to include('cvc') }
    it { expect(subject.request(common, method, options)).to include('name') }
    it { expect(subject.request(common, method, options)).to include('number') }
    it { expect(subject.request(common, method, options)).to include('exp_year') }
    it { expect(subject.request(common, method, options)).to include('exp_month') }
    it { expect(subject.request(common, method, options)).to include('address') }

    describe 'address is valid' do
      it { expect(subject.request(common, method, options)['address']).to include('street1') }
      it { expect(subject.request(common, method, options)['address']).to include('street2') }
    end
  end
end
