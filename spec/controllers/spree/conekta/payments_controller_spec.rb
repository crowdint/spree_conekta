require 'spec_helper'
require 'celluloid'

describe Spree::Conekta::PaymentsController do
#  render_views
  routes { Spree::Core::Engine.routes }

  before do
    DatabaseCleaner.clean
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  let(:conekta_response){
    {
      "data"=>{
        "object"=>{
          "id"=>"5213ecbf9328af245f00000a",
          "livemode"=>"false",
          "created_at"=>"1377037504",
          "status"=>"paid",
          "currency"=>"MXN",
          "description"=>"R706552773-5TAPHAJT",
          "failure_code"=>"",
          "failure_message"=>"",
          "amount"=>"10040",
          "processed_at"=>"0",
          "fee"=>"233",
          "customer"=>{
            "name"=>"Jonathan Garay",
            "phone"=>"3123123",
            "email"=>""
          }
        }
      },
      "created_at"=>"1377037506",
      "type"=>"charge.paid",
      "id"=>"5213ecc29328af245f00000f"
    }
  }

  let(:reference){ conekta_response['data']['object']['reference_id'] = "RT#{rand(0..1000)}-XCVBC" }
  let(:order_number){ reference.split('-')[0] }
  let(:order){ create(:order_with_totals, number: order_number) }

  before do
    create(:payment, order: order,
           state: "pending",
           amount: order.outstanding_balance,
           payment_method: create(:bogus_payment_method, environment: 'test'))

  end

  describe :create do
    context 'The order is completed and a pending payment exist' do
      before do
        Spree::Conekta::PaymentNotificationHandler.any_instance.stub delay: 1
        post :create, conekta_response
      end

      it 'should mark a payment as completed' do
        sleep 2
        expect(Spree::Payment.joins(:order).where(spree_orders: {number: order_number }).last).to be_completed
      end
    end
  end
end
