@OpCart =
  ready: ->
    if $('body').is '.op_cart-orders-new, .op_cart-orders-create'
      $number = $ '#credit_card_number'
      $expiry = $ '#credit_card_expiry'
      $cvc    = $ '#credit_card_cvc'

      if $('#card_form_inputs')
        $number.payment 'formatCardNumber'
        $expiry.payment 'formatCardExpiry'
        $cvc.payment 'formatCardCVC'

      $('#shipping_address_postal_code').change => @updateZipFields()

      @updateZipFields()
      @updateDisplayedQuantities()
      @stripeCreateToken()

  load: ->
    OpCart.ready()

  updateZipFields: ->
    $locality = $ '#shipping_address_locality'
    $region   = $ '#shipping_address_region'
    $zip      = $ '#shipping_address_postal_code'

    if $zip.val().length == 5
      $.ziptastic $zip.val(), (country, region, region_short, locality, zip) ->
        $locality.val locality
        $region.val region
      $locality.prop "disabled", false
      $region.prop "disabled", false


  stripeCreateToken: ->
    $("#new_order").submit (event) ->
      $form = $(this)
      $form.find("button").prop "disabled", true

      Stripe.setPublishableKey $form.data("stripe-key")

      expiration = $("#credit_card_expiry").payment "cardExpiryVal"

      Stripe.card.createToken
        number: $("#credit_card_number").val()
        cvc: $("#credit_card_cvc").val()
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
        errorMessage = 'Email or shipping information missing' #TODO: what else is missing?
      $form.find(".payment-errors").text errorMessage
      $form.find("button").prop "disabled", false
    else
      $('#order_card_token').val response.id
      $('#order_details').remove()
      $form.get(0).submit()

  addItemToOrder: (productId, quantity) ->
    currentQuantity = @lineItemQuantity productId
    @lineItemQuantity productId, currentQuantity + 1
    @updateDisplayedQuantity productId

  removeItemFromOrder: (productId) ->
    @lineItemQuantity productId, 0
    @updateDisplayedQuantity productId

  updateDisplayedQuantities: ->
    $('[data-product-id]').each -> OpCart.updateDisplayedQuantity $(@).data('product-id')

  updateDisplayedQuantity: (productId) ->
    $quantity = $ "#line_item_product_#{productId} .quantity"
    $quantity.html @lineItemQuantity(productId)

  lineItemQuantity: (productId, quantity) ->
    $liQuantities = $ '#line_items_quantities_json'
    liQuantities = JSON.parse $liQuantities.val() || "{}"

    if quantity >= 0
      liQuantities[productId] = quantity
      $liQuantities.val JSON.stringify(liQuantities)
    else
      liQuantities[productId] || 0

$ -> OpCart.ready()
$(document).on 'page:load', OpCart.load
