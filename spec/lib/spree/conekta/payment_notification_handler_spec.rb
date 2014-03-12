require 'spec_helper'

describe Spree::Conekta::PaymentNotificationHandler do
  let(:payment) { double(Spree::Payment) }

  let(:notification) do
    {
      'type' => 'charge.paid',
      'data' => {
        'object' => {
          'reference_id' => 'foobar'
        }
      }
    }
  end

  describe '#perform_action' do

    subject { described_class.new(notification, 1) }

    it 'runs the given action after a given time' do
      Spree::Payment.should_receive(:find_by_order_number).with('foobar').and_return payment
      payment.should_receive :capture!

      subject.perform_action
      sleep 2
    end
  end
end
