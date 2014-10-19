require 'spec_helper'

RSpec.describe Spree::Conekta::Client, type: :model do
  subject { double('client').extend Spree::Conekta::Client }

  describe :headers do
    let(:token){ 'abc12345678' }
    let(:auth_token){ Base64.encode64(token)}

    before { allow(subject).to receive(:auth_token).and_return token }

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
      allow(subject).to receive_messages(endpoint: 'charges')
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
