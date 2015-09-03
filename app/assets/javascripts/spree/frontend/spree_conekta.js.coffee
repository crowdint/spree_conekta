#= require conekta
#= require_tree .
#= require_self

jQuery ->
  class Spree.Conekta
    currentMethod: null

    constructor: (@form, @gatewayOptions)->
      @methods       = @form.find 'input[name="order[payments_attributes][][payment_method_id]"]'
      @currentMethod = @methods.filter(':checked').val()
      @listenMethodChange()
      @listenSubmit()

    listenSubmit: ->
      @form.on 'submit', (e)=>
        e.preventDefault()
        currentForm = @cleanForm()
        if @isConektaForm(currentForm)
          @processPayment(currentForm)
        else
          @submitForm()

    isConektaForm: (form)->
      $('input', form).is("[data-conekta='card[name]']")

    generateToken: (form)->
      window.Conekta.token.create(form, @successResponseHandler, @errorResponseHandler)

    processPayment: (form)->
      @generateToken(form)

    processWithInstallments: (form)->
      $.extend(@gatewayOptions, window.Conekta._helpers.parseForm(form))
      window.Conekta.charge.create(@gatewayOptions, @successResponseHandler, @errorResponseHandler)

    cleanForm: ->
      form = @form.clone()
      form.find("li:not(#payment_method_#{@currentMethod})").remove()
      form

    listenMethodChange: ->
      @methods.on 'change', (e)=>
        @currentMethod = e.target.value

    withInstallments: (form)->
      $('select, input', form).is("[data-conekta='monthly_installments']")

    submitForm: ->
      @form.off('submit')
      @form.submit()

    successResponseHandler: (response)=>
      @saveConektaResponse(response)
      @submitForm()

    errorResponseHandler: (response)=>
      @saveConektaResponse(response)
      @submitForm()

    saveConektaResponse: (response)->
      @form.find("input[name='payment_source[#{@currentMethod}][gateway_payment_profile_id]']").val(response.id)
      @form.find("input[name='payment_source[#{@currentMethod}][conekta_response]']").val(JSON.stringify(response))
