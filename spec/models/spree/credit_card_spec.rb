require 'spec_helper'

describe Spree::CreditCard do
  describe '#name' do
    context 'When name_on_card is present' do
      before do
        subject.name_on_card = 'foo'
      end

      specify "name should be name_on_card" do
        expect(subject.name).to eq 'foo'
      end
    end

    context 'When name_on_card is not present and first name and last name are present' do
      before do
        subject.first_name = 'foo'
        subject.last_name  = 'bar'
      end

      specify "name should be the first and last name" do
        expect(subject.name).to eq 'foo bar'
      end
    end
  end

end
