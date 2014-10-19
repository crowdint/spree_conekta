require 'spec_helper'

RSpec.describe Spree::Conekta::Provider, type: :model do
  describe 'payment_procesor' do
    context 'the payment source is card' do
      it { expect(subject.payment_processor('card')).to be(Spree::Conekta::PaymentSource::Card) }
    end

    context 'the payment source is bank' do
      it { expect(subject.payment_processor('bank')).to be(Spree::Conekta::PaymentSource::Bank) }
    end

    context 'the payment source is cash' do
      it { expect(subject.payment_processor('cash')).to be(Spree::Conekta::PaymentSource::Cash) }
    end
  end

  describe '#endpoint' do
    specify { expect(subject.endpoint).to eq 'charges' }
  end

  describe '#capture' do
    specify { expect(subject.capture(10, double)).to be_a_kind_of Spree::Conekta::Response }
  end

  describe '#authorize' do
    let(:gateway_options) do
      {
        order_id: 'foo123',
        currency: 'MXN',
        billing_address: {},
        shipping_address: {},
      }
    end

    before do
      subject.auth_token = '1tv5yJp3xnVZ7eK67m4h'
    end

    context 'When a credit card' do
      let(:method_params) do
        double 'method', first_name: 'foo',
                         last_name: 'bar',
                         verification_value: '123',
                         number: '4242424242424242',
                         year: '2014',
                         month: '8',
                         gateway_payment_profile_id: 'tok_test_visa_4242',
                         installments_number: nil
      end

      before do
        subject.stub source_method: Spree::Conekta::PaymentSource::Card
        subject.stub line_items: [{ name: 'foo', description: 'var' }]
      end

      it 'authorizes a transaction' do
        VCR.use_cassette('card_transaction') do
          expect(subject.authorize(10000, method_params, gateway_options)).to be_success
        end
      end
    end

    context 'When a bank transaction' do
      let(:method_params) { {} }

      before do
        subject.stub source_method: Spree::Conekta::PaymentSource::Bank
        subject.stub line_items: [{ name: 'foo', description: 'var' }]
      end

      it 'authorizes a transaction' do
        VCR.use_cassette('bank_transaction') do
          expect(subject.authorize(10000, method_params, gateway_options)).to be_success
        end
      end
    end

    context 'When a cash transaction' do
      let(:method_params) { {} }

      before do
        subject.stub source_method: Spree::Conekta::PaymentSource::Cash
        subject.stub line_items: [{ name: 'foo', description: 'var' }]
      end

      it 'authorizes a transaction' do
        VCR.use_cassette('cash_transaction') do
          expect(subject.authorize(10000, method_params, gateway_options)).to be_success
        end
      end
    end
  end

  describe '#supports?' do
    it 'does not support amex' do
      expect(subject.supports?('american_express')).to be false
    end

    it 'supports visa' do
      expect(subject.supports?('visa')).to be true
    end

    it 'supports master card' do
      expect(subject.supports?('master')).to be true
    end
  end
end
