require 'spec_helper'

describe Spree::Conekta::Client do
  subject { double('client').extend Spree::Conekta::Client }

  describe :headers do
    let(:token){ 'abc12345678' }
    let(:auth_token){ Base64.encode64(token)}

    before { subject.stub(:auth_token).and_return token }

    it "should return headers with auth token" do
      expect(subject.headers).to include 'Accept', 'Content-type'
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
      subject.stub endpoint: 'charges'
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
