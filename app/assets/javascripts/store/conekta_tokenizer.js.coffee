class Conekta.Tokenizer
  constructor: (@$form)->
    @listenSubmit()

  tokenize: ->
    window.Conekta.token.create(@$form, @successResponseHandler, @errorResponseHandler)

  listenSubmit: ->
    @$form.on 'submit', (e)=>
      e.preventDefault()
      @tokenize()

  successResponseHandler: (response)=>
    @$form.find('.token').val response.id
    @submitForm()

  errorResponseHandler: (response)=>
    $('#content').prepend "<div class='flash error'>#{response.message}</div>"

  submitForm: ->
    @$form.off('submit').submit()
