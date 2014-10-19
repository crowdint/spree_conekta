require 'spec_helper'

RSpec. describe 'spree/conekta/payments/show', type: :view do
  let(:order){ create(:order_with_totals, number: 'RT1234567', currency: 'MXN') }
  let(:conekta_pending_response) do
    OpenStruct.new params:  {
      "id"=> "52260de18dce00317d0000ce",
      "livemode"=> false,
      "created_at"=> 1378225633,
      "status"=> "pending_payment",
      "currency"=> "MXN",
      "description"=> "DVD - Zorro",
      "reference_id"=> nil,
      "failure_code"=> nil,
      "failure_message"=> nil,
      "object"=> "charge",
      "amount"=> 10000,
      "processed_at"=> nil,
      "fee"=> 649,
      "customer"=> {
        "name"=> "Gilberto Gil",
        "phone"=> "5567942342",
        "email"=> "gil.gil@mypayments.mx"
      }
    }
  end

  before do
    allow_any_instance_of(Spree::Order).to receive(:last_payment_details).and_return(conekta_pending_response)

    assign(:order, order)
    assign(:order_details, conekta_pending_response.params)
  end

  context 'The payment source is card' do
    before do
      conekta_pending_response.params['card'] = {
        "name" => "Gilberto Gil",
        "last4"=> "4111111111111111",
        "processing_response"=> nil,
        "fraud_response"=> "3d_secure_required",
        "redirect_form"=> {
          "url"=> "https=> //eps.banorte.com/secure3d/Solucion3DSecure.htm",
          "action"=> "POST",
          "attributes"=> {
            "MerchantId"=> "7376961",
            "MerchantName"=> "GRUPO CONEKTAME",
            "MerchantCity"=> "EstadodeMexico",
            "Cert3D"=> "03",
            "ClientId"=> "60518",
            "Name"=> "7376962",
            "Password"=> "fgt563j",
            "TransType"=> "Auth",
            "Mode"=> "P",
            "E1"=> "XHj7GsiJaWBy3Zgkj93z",
            "E2"=> "51e17bcbcdc948643a000006",
            "E3"=> "P",
            "ResponsePath"=> "https://eps.banorte.com/RespuestaCC.jsp",
            "CardType"=> "VISA",
            "Card"=> "4111111111111111",
            "Cvv2Indicator"=> "1",
            "Cvv2Val"=> "000",
            "Expires"=> "04/16",
            "Total"=> "100.0",
            "ForwardPath"=> "https://api.conekta.io/charges/banorte_3d_secure_response",
            "auth_token"=> "XHj7GsiJaWBy3Zgkj93z"
          }
        }
      }

      allow_any_instance_of(Spree::Order).to receive(:last_payment_source).and_return('card')
      render
    end

    it{ expect(view).to render_template(partial: '_card') }
  end


  context 'The payment source is card' do
    before do
      conekta_pending_response.params['payment_method'] ={
        "type"=>"oxxo",
        "expiry_date"=>"300713",
        "barcode"=>"38100000000042290121213001160013",
        "barcode_url"=>"https://www2.oxxo.com:8443/HTP/barcode/genbc?data=38100000000042290121213001160013&height=50&width=1&type=Code128"
      }


      allow_any_instance_of(Spree::Order).to receive(:last_payment_source).and_return('cash')
      render
    end

    it{ expect(view).to render_template(partial: '_cash') }
  end


  context 'The payment source is bank' do
    before do
      conekta_pending_response.params['payment_method'] ={
        "type"=>"Banorte",
        "service_name"=>"Conekta",
        "service_number"=>"127589",
        "reference"=>"0000064"
      }

      allow_any_instance_of(Spree::Order).to receive(:last_payment_source).and_return('bank')
      render
    end

    it{ expect(view).to render_template(partial: '_bank') }
  end


end
