require 'spec_helper'

describe Spree::Conekta::Payworks do
  let(:card) do
    {
      "name" => "Gilberto Gil",
      "last4" => "1111",
      "fraud_response" => "3d_secure_required",
      "redirect_form" =>  {
        "url" => "https://eps.banorte.com/secure3d/Solucion3DSecure.htm",
        "action" => "POST",
        "attributes" =>  {
          "MerchantId" => "7376961",
          "MerchantName" => "GRUPO CONEKTAME",
          "MerchantCity" => "EstadodeMexico",
          "Cert3D" => "03",
          "ClientId" => "60518",
          "Name" => "7376962",
          "Password" => "fgt563j",
          "TransType" => "Auth",
          "Mode" => "Y",
          "E1" => "'1tv5yJp3xnVZ7eK67m4h'",
          "E2" => "51f193f4727c0dafe100000b",
          "E3" => "Y",
          "ResponsePath" => "https://eps.banorte.com/RespuestaCC.jsp",
          "CardType" => "VISA",
          "Card" => "4111111111111111",
          "Cvv2Indicator" => "1",
          "Cvv2Val" => "000",
          "Expires" => "04/16",
          "Total" => "100.0",
          "ForwardPath" => "https://paymentsapi-dev.herokuapp.com/charges/banorte_3d_secure_response",
          "auth_token" => "1tv5yJp3xnVZ7eK67m4h"
        }
      }
    }
  end

  subject{
    Spree::Conekta::Payworks.new(card)
  }

  let(:form_url){ 'http://action.com/' }

  let(:html_form){
    <<-FORM
      <html>
        <form action="#{form_url}">
           First name: <input type="text" name="firstname" value='val1'><br>
           Last name: <input type="text" name="lastname" value='val2'>
        </form>
      </html>
      FORM
  }

  describe :extract_form do
    it 'shoult return the form information' do
      url, params = subject.extract_form(html_form)
      expect(url).to be_eql(form_url)
      expect(params).to include("firstname", "lastname")
    end
  end

end
