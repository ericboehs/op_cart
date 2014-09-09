OpCart =
  ready: ->
      $number = $ '#order_credit_card_number'
      $expiry = $ '#order_credit_card_expiry'
      $cvc    = $ '#order_credit_card_cvc'

      $number.payment 'formatCardNumber'
      $expiry.payment 'formatCardExpiry'
      $cvc.payment 'formatCardCVC'

      @stripeCreateToken()

  load: -> @ready()

  stripeCreateToken: ->
    $("#new_order").submit (event) ->
      $form = $(this)
      $form.find("button").prop "disabled", true

      expiration = $("#order_credit_card_expiry").payment "cardExpiryVal"

      Stripe.card.createToken
        number: $("#order_credit_card_number").val()
        cvc: $("#order_credit_card_cvc").val()
        exp_month: expiration.month || 0
        exp_year: expiration.year || 0
      , OpCart.stripeResponseHandler

      false # Prevent the form from submitting with the default action

  stripeResponseHandler: (status, response) ->
    $form = $("#new_order")

    debugger
    if response.error || !$form.get(0).checkValidity()
      if response.error
        errorMessage = response.error.message
      else
        errorMessage = 'Email or shipping information missing'
      $form.find(".payment-errors").text errorMessage
      $form.find("button").prop "disabled", false
    else
      $form.append $("<input type=\"hidden\" name=\"stripeToken\" />").val(response.id)
      $form.get(0).submit()


$ -> OpCart.ready()
$(document).on 'page:load', -> OpCart.load()

