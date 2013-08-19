require 'spec_helper'

describe Spree::Conekta::PaymentsController do
  routes { Spree::Core::Engine.routes }

  let(:conekta_response){
    {"_id"=>"521266d9ab94e9122e0000e4",
     "data"=>{
         "object"=>{
             "id"=>"521266d8ab94e9122e0000e3",
             "livemode"=>"false",
             "created_at"=>"1376937689",
             "status"=>"pending_payment",
             "currency"=>"MXN",
             "description"=>"R987654321-JG2EM438",
             "reference_id"=>"R987654321-JG2EM438",
             "failure_code"=>"",
             "failure_message"=>"",
             "amount"=>"10002",
             "processed_at"=>"",
             "fee"=>"231",
             "customer"=>{
                 "name"=>"Jonathan Garay",
                 "phone"=>"3123123",
                 "email"=>""
             },
             "card"=>{
                 "name"=>"Jonathan Garay",
                 "exp_month"=>"08",
                 "exp_year"=>"18",
                 "country"=>"Mexico",
                 "brand"=>"VISA",
                 "last4"=>"4111111111111111"}
         },
         "previous_attributes"=>{
             "livemode"=>"",
             "amount"=>"",
             "created_at"=>"0",
             "status"=>"",
             "currency"=>"",
             "description"=>"",
             "reference_id"=>"",
             "card"=>{
                 "name"=>"",
                 "country"=>""
             }
         }
     },
     "eventable_id"=>"521266d8ab94e9122e0000e3",
     "eventable_type"=>"Charge",
     "updated_at"=>"2013-08-19 18:41:29 UTC",
     "created_at"=>"2013-08-19 18:41:29 UTC",
     "type"=>"charge.paid"
    }
  }

  describe :create do
    context 'The order is completed' do
      let(:order_number){ conekta_response['data']['object']['reference_id'].split('-')[0] }

      before do
        create(:order_with_totals, :number => 'R987654321', state: 'cart')
        post :create, conekta_response
      end

      it 'should mark a payment as completed' do
        expect(Spree::Order.last).to be_completed
      end
    end
  end
end
