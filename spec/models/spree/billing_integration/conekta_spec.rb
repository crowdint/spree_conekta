require 'spec_helper'

RSpec.describe Spree::BillingIntegration::Conekta, type: :model do
  context 'When Spree::Config[:auto_capture] is set to true' do
    before do
      Spree::Config[:auto_capture] = true
    end

    specify { expect(subject.auto_capture?).to eq(false) }
  end
end
