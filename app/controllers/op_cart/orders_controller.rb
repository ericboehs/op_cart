module OpCart
  class OrdersController < ApplicationController
    # before_action :authenticate_user!, only: [:show, :edit, :update, :destroy]
    before_action :set_order, only: [:show, :edit, :update, :destroy]

    def new
      @products = Product.all
      @order = Order.new
    end

    def create
      @order = Order.new order_params
      @order.status = :new
      @order.user = current_user || User.first #TODO: Create a user from email
      add_line_items

      if @order.save
        redirect_to @order, notice: 'Thank you for your purchase'
      else
        render :new
      end
    end

    def show
    end

    private

    def set_order
      # TODO prevent viewing of others' orders
      # @order = current_user.orders.find params[:id]
      @order = Order.find params[:id]
    end

    def order_params
      params.require(:order).permit(:email, :card_token,
        { shipping_address: [ :full_name, :address, :zip_code, :city, :state ] }
      )
    end

    def add_line_items
      li_quantities_json = JSON.parse params[:line_items][:quantities]
      li_quantities_json.each do |product_id, quantity|
        @order.line_items <<
          LineItem.new(sellable: Product.find(product_id), quantity: quantity)
      end
    end

  end
end
