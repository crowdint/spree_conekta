require 'spec_helper'

RSpec.describe Spree::ConektaPayment, type: :model do
  describe '#actions' do
    it { expect(subject.actions).to eql(['capture']) }
  end

  describe '#can_capture?' do
    let(:payment) { double('Payment') }

    context 'when payment state is checkout' do
      before do
        allow(payment).to receive(:state) { 'checkout' }
      end

      it { expect(subject.can_capture?(payment)).to eq(true) }
    end

    context 'when payment state is pending' do
      before do
        allow(payment).to receive(:state) { 'pending' }
      end

      it { expect(subject.can_capture?(payment)).to eq(true) }
    end

    context 'when payment state is different than checkout or pending' do
      before do
        allow(payment).to receive(:state) { 'invalid' }
      end

      it { expect(subject.can_capture?(payment)).to eq(false) }
    end
  end
end
