OpCart =
  ready: ->
    if $('body').is '.op_cart-orders-new'
      $number = $ '#order_credit_card_number'
      $expiry = $ '#order_credit_card_expiry'
      $cvc    = $ '#order_credit_card_cvc'
      $city   = $ '#order_shipping_address_city'
      $state  = $ '#order_shipping_address_state'
      $zip    = $ '#order_shipping_address_zip_code'

      $number.payment 'formatCardNumber'
      $expiry.payment 'formatCardExpiry'
      $cvc.payment 'formatCardCVC'

      $zip.change ->
        if $zip.val().length == 5
          $.ziptastic $zip.val(), (country, state, state_short, city, zip) ->
            $city.val city
            $state.val state
          $city.prop "disabled", false
          $state.prop "disabled", false

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

