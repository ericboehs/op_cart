module OpCart
  class OrdersController < ApplicationController
    def new
      @products = [Product.first] # Temp hack to display first product as order
      @order = Order.new
    end

    def create
      product = Product.find params[:product_id]

      customer = Stripe::Customer.create(
        card: params[:stripeToken],
        email: params[:order][:email]
      )

      # TODO Create Order w/ Line Items
      # TODO Create shipping address

      Stripe::Charge.create(
        amount: product.price,
        currency: "usd",
        customer: customer.id
      )

      redirect_to new_order_path, notice: 'Thank you for your purchase'
    rescue Stripe::CardError => e
      # The card has been declined or some other error has occurred
      @error = e
      render :new
    end
  end
end
