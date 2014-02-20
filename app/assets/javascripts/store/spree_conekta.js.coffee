#= require conekta
#= require_tree .
#= require_self

jQuery ->
  class Spree.Conekta
    currentMethod: null

    constructor: (@form)->
      @methods       = @form.find 'input[name="order[payments_attributes][][payment_method_id]"]'
      @currentMethod = @methods.filter(':checked').val()
      @listenMethodChange()
      @listenSubmit()

    listenSubmit: ->
      @form.on 'submit', (e)=>
        e.preventDefault()
        currentForm = @cleanForm()
        if @isConektaForm(currentForm)
          @generateToken(currentForm)
        else
          @submitForm()

    isConektaForm: (form)->
      $('input', form).is("[data-conekta='card[name]']")

    generateToken: (form)->
      window.Conekta.token.create(form, @tokenSuccessResponseHandler, @tokenErrorResponseHandler)

    cleanForm: ->
      form = @form.clone()
      form.find("li:not(#payment_method_#{@currentMethod})").remove()
      form

    listenMethodChange: ->
      @methods.on 'change', (e)=>
        @currentMethod = e.target.value

    submitForm: ->
      @form.off('submit')
      @form.submit()

    tokenSuccessResponseHandler: (response)=>
      @form.find("input[name='payment_source[#{@currentMethod}][gateway_payment_profile_id]']").val(response.id)
      @submitForm()

    tokenErrorResponseHandler: (response)=>
      @submitForm()
