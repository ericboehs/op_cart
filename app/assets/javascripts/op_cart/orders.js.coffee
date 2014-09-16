@OpCart =
  ready: ->
    if $('body').is '.op_cart-orders-new'
      $number = $ '#order_credit_cards_number'
      $expiry = $ '#order_credit_cards_expiry'
      $cvc    = $ '#order_credit_cards_cvc'
      $city   = $ '#order_shipping_addresses_city'
      $state  = $ '#order_shipping_addresses_state'
      $zip    = $ '#order_shipping_addresses_zip_code'

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

      Stripe.setPublishableKey $form.data("stripe-key")

      expiration = $("#order_credit_cards_expiry").payment "cardExpiryVal"

      Stripe.card.createToken
        number: $("#order_credit_cards_number").val()
        cvc: $("#order_credit_cards_cvc").val()
        exp_month: expiration.month || 0
        exp_year: expiration.year || 0
      , OpCart.stripeResponseHandler

      false # Prevent the form from submitting with the default action

  stripeResponseHandler: (status, response) ->
    $form = $("#new_order")

    if response.error || !$form.get(0).checkValidity()
      if response.error
        errorMessage = response.error.message
      else
        errorMessage = 'Email or shipping information missing'
      $form.find(".payment-errors").text errorMessage
      $form.find("button").prop "disabled", false
    else
      $('#order_card_token').val response.id
      $form.get(0).submit()

  addItemToOrder: (productId, quantity) ->
    currentQuantity = @lineItemQuantity productId
    @lineItemQuantity productId, currentQuantity + 1
    @updateDisplayedQuantity productId

  removeItemFromOrder: (productId) ->
    @lineItemQuantity productId, 0
    @updateDisplayedQuantity productId

  updateDisplayedQuantity: (productId) ->
    $quantity = $ "#line_item_product_#{productId} .quantity .value"
    $quantity.html @lineItemQuantity(productId)

  lineItemQuantity: (productId, quantity) ->
    $liQuantities = $ '#line_items_quantities'
    liQuantities = JSON.parse $liQuantities.val() || "{}"

    if quantity >= 0
      liQuantities[productId] = quantity
      $liQuantities.val JSON.stringify(liQuantities)
    else
      liQuantities[productId] || 0

$ -> OpCart.ready()
$(document).on 'page:load', OpCart.load

