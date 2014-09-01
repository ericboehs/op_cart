OpCart =
  ready: -> @stripeCreateToken()
  load: -> @ready()

  stripeCreateToken: ->
    $("#payment-form").submit (event) ->
      $form = $(this)

      $form.find("button").prop "disabled", true
      Stripe.card.createToken $form, OpCart.stripeResponseHandler

      false # Prevent the form from submitting with the default action

  stripeResponseHandler: (status, response) ->
    $form = $("#payment-form")

    debugger
    if response.error
      $form.find(".payment-errors").text response.error.message
      $form.find("button").prop "disabled", false
    else
      $form.append $("<input type=\"hidden\" name=\"stripeToken\" />").val(response.id)
      $form.get(0).submit()

$ -> OpCart.ready()
$(document).on 'page:load', -> OpCart.load()

