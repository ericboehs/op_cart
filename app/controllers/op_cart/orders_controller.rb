module OpCart
  class OrdersController < ApplicationController
    # before_action :authenticate_user!, only: [:show, :edit, :update, :destroy]
    before_action :set_order, only: [:show, :edit, :update, :destroy]

    def new
      @products = Product.all
      @order = Order.new
      @order.line_items << LineItem.new
      @plan = Plan.purchasable.find(params[:plan_id]) if params[:plan_id]
      @user = current_user || User.new
      @card = current_user.try(:customer).try :default_card
      @shipping_address = @user.shipping_addresses.first || @user.shipping_addresses.new
    end

    def create
      @order = Order.new order_params
      @user = current_user || @order.user
      add_user
      add_line_items
      add_shipping_address

      if @order.save
        sign_in @order.user
        redirect_to @order, notice: 'Thank you for your purchase'
      else
        @products = Product.all
        @user = User.new user_params unless signed_in?
        @card = current_user.try(:customer).try :default_card
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

    def user_params
      params.require(:user).permit :email, :password
    end

    def add_line_items
      @line_items = OpenStruct.new(quantities_json: line_items_params[:quantities_json] || {})
      if @line_items.quantities_json.present?
        li_quantities_json = JSON.parse @line_items.quantities_json
        li_quantities_json.each do |plan_id, quantity|
          plan = Plan.find plan_id
          @order.line_items << LineItem.new(sellable: plan, quantity: quantity)
          plan.plan_addons.each do |addon|
            @order.line_items << LineItem.new(sellable: addon.product, quantity: quantity)
          end
        end
      end
    end

    def add_user
      if !signed_in? && !@order.user
        if user = find_user
          if valid_password? user
            @order.user = @user = user
          else
            flash.now[:alert] = 'A user with that email already exists. Please sign in or pick another email.'
          end
        else
          @order.user = @user = new_user
        end
      else
        @order.user = current_user
      end
    end

    def find_user
      User.find_by email: params[:user][:email]
    end

    def valid_password? user
      user.valid_password? params[:user][:password]
    end

    def new_user
      user = User.new(user_params.merge(
        name: shipping_address_params[:full_name],
        password_confirmation: user_params[:password]
      ))
      user.valid? && user
    end

    def add_shipping_address
      @order.shipping_address = @shipping_address = ShippingAddress.new(
        shipping_address_params.merge user_id: @user.try(:id)
      )
    end
  end
end
