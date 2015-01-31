module OpCart
  class OrdersController < ApplicationController
    # before_action :authenticate_user!, only: [:show, :edit, :update, :destroy]
    before_action :set_order, only: [:show, :edit, :update, :destroy]

    def new
      @products = Product.all #TODO: Move to find_products
      @order = Order.new
      if signed_in?
        @shipping_address = current_user.shipping_addresses.first
      end
    end

    def create
      @products = Product.all
      @order = Order.new order_params #TODO: Move to set_order
      add_user
      add_line_items
      add_shipping_address

      if signed_in? && @order.save
        redirect_to @order, notice: 'Thank you for your purchase'
      else
        # TODO Set flash w/ error
        render :new
      end
    end

    def show; end

    private

    def set_order
      @order = current_user.orders.find params[:id]
    end

    def order_params
      params.require(:order).permit :email, :password, :processor_token
    end

    def line_items_params
      params.require(:line_items).permit :quantities_json
    end

    def shipping_address_params
      params.require(:shipping_address).permit :full_name, :street, :postal_code,
        :locality, :region
    end

    def add_line_items
      @line_items = OpenStruct.new(quantities_json: line_items_params[:quantities_json] || {})
      li_quantities_json = JSON.parse @line_items.quantities_json
      li_quantities_json.each do |product_id, quantity|
        @order.line_items <<
          LineItem.new(sellable: Product.find(product_id), quantity: quantity)
      end
    end

    def add_user
      if current_user.blank? && user = User.find_by(email: params[:user][:email])
        if user.valid_password? params[:user][:password]
          sign_in user
        else
          flash[:alert] = 'A user with that email already exists. Please sign in or pick another email.'
          return false
        end
      end

      unless signed_in?
        sign_in User.create name: params[:shipping_address][:full_name],
          email: params[:user][:email], password: params[:user][:password],
          password_confirmation: params[:user][:password]
      end
      @order.user = current_user
    end

    def add_shipping_address
      @order.shipping_address = @shipping_address ||= ShippingAddress.create(
        shipping_address_params.merge user_id: current_user.try(:id)
      )
    end
  end
end
