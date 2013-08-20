require 'spec_helper'

describe Spree::Conekta::PaymentsController do
  routes { Spree::Core::Engine.routes }

  let(:conekta_response){
    {
      "id"=>"51CEF9FAF23668B1F4000001",
      "created_at"=>"1376949736",
      "livemode"=>"false",
      "type"=>"charge.paid",
      "data"=>{
        "object"=>{
          "id"=>"51D5EA80DB49596AA9000001",
          "created_at"=>"1376949731",
          "amount"=>"10000",
          "fee"=>"310",
          "currency"=>"MXN",
          "status"=>"paid",
          "livemode"=>"false",
          "description"=>"E-Book: Les Miserables",
          "error"=>"",
          "error_message"=>"",
          "dispute"=>"",
          "card"=>{
            "last4"=>"1111",
            "name"=>"Arturo Octavio Ortiz"
          }
        },
        "previous_attributes"=>
        {
          "status"=>"payment_pending"
        }
      }
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
