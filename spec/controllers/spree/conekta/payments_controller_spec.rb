require 'spec_helper'

describe Spree::Conekta::PaymentsController do
  routes { Spree::Core::Engine.routes }

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
          "reference_id"=>"R706552773-5TAPHAJT",
          "failure_code"=>"",
          "failure_message"=>"",
          "amount"=>"10040",
          "processed_at"=>"0",
          "fee"=>"233",
          "customer"=>{
            "name"=>"Jonathan Garay",
            "phone"=>"3123123",
            "email"=>""
          },
          "card"=>{
            "name"=>"Jonathan Garay",
            "exp_month"=>"09",
            "exp_year"=>"25",
            "country"=>"Mexico",
            "brand"=>"VISA",
            "last4"=>"1111"
          }
        }
      },
      "created_at"=>"1377037506",
      "type"=>"charge.paid",
      "id"=>"5213ecc29328af245f00000f"
    }
  }

  describe :create do
    context 'The order is completed and a pending payment exist' do
      let(:order_number){ conekta_response['data']['object']['reference_id'].split('-')[0] }

      before do
        order = create(:order_with_totals, :number => 'R706552773')
        create(:payment, :order => order,
               :state => "pending",
               :amount => order.outstanding_balance,
               :payment_method => create(:bogus_payment_method, :environment => 'test'))
        post :create, conekta_response
      end

      it 'should mark a payment as completed' do
        expect(Spree::Payment.joins(:order).where(spree_orders: {number: order_number }).first).to be_completed
      end
    end
  end
end
