module OpCart
  class OrdersController < ApplicationController
    def new
      @product = Product.first # Temp hack to display first product as order
    end

    def create
      product = Product.find params[:product_id]

      charge = Stripe::Charge.create(
        amount:   product.price,
        currency: "usd",
        card:     params[:stripeToken]
      )

      redirect_to new_order_path, notice: 'Thank you for your purchase'
    rescue Stripe::CardError => e
      # The card has been declined or some other error has occurred
      @error = e
      render :new
    end
  end
end
