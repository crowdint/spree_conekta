#= require conekta
#= require_tree .
#= require_self

jQuery ->
  class Spree.Conekta
    constructor: (@form)->

    tokenSuccessResponseHandler: (response)=>
      @form.find('#gateway_payment_profile_id').val(response.id)
      @form.off('submit')
      @form.submit()

    tokenErrorResponseHandler: (response)=>
      @form.off('submit')
      @form.submit()
