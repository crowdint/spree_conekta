require 'spec_helper'

describe Spree::Conekta::Client do
  describe :payment_procesor do
    context "the payment source is card" do
      it { expect(subject.payment_processor('card')).to be(Spree::Conekta::PaymentSource::Card) }
    end

    context "the payment source is bank" do
      it { expect(subject.payment_processor('bank')).to be(Spree::Conekta::PaymentSource::Bank) }
    end

    context "the payment source is cash" do
      it { expect(subject.payment_processor('cash')).to be(Spree::Conekta::PaymentSource::Cash) }
    end
  end

  describe :headers do
    let(:token){ 'abc12345678' }
    before { subject.stub(:auth_token).and_return token }

    it "should return headers with auth token" do
      expect(subject.headers).to include 'Accept', 'Content-type', 'Authorization'
    end

    it "should include the authorization token" do
      expect(subject.headers['Authorization']).to match(/#{token}/)
    end
  end

  describe :post do
    let(:json) do
      {
        header: 'value',
        test: 'value2'
      }.to_json
    end

    before do
      subject.stub_chain(:connection, :post, :body).and_return(json)
    end

    it 'should return parsed body' do
      expect(subject.post({})).to be_a(Hash)
    end
  end

  describe :connection do
    it "should return a faraday connection" do
      expect(subject.connection).to be_a(Faraday::Connection)
    end

    it "should include headers" do
      expect(subject.connection.headers).to include(subject.headers)
    end
  end
end
