module OpCart
  class OrdersController < ApplicationController
    # before_action :authenticate_user!, only: [:show, :edit, :update, :destroy]
    before_action :set_order, only: [:show, :edit, :update, :destroy]

    def new
      @products = Product.all
      @order = Order.new
    end

    def create
      @products = Product.all
      @order = Order.new order_params
      if current_user.blank? && user = User.find_by(email: params[:user][:email])
        if user.valid_password? params[:user][:password]
          sign_in user
        else
          flash[:alert] = 'A user with that email already exists. Please sign in or pick another email.'
          return render :new
        end
      end
      sign_in create_user unless signed_in?
      @order.user = current_user
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

    def create_user
      User.create name: params[:order][:shipping_address][:full_name], email: params[:user][:email],
        password: params[:user][:password], password_confirmation: params[:user][:password]
    end

    def set_order
      # TODO prevent viewing of others' orders
      # @order = current_user.orders.find params[:id]
      @order = Order.find params[:id]
    end

    def order_params
      params.require(:order).permit(:email, :password, :card_token#,
        # { shipping_address: [ :full_name, :address, :zip_code, :city, :state ] },
      )
    end

    def line_items_params
      params.require(:line_items).permit :quantities
    end

    def add_line_items
      li_quantities_json = JSON.parse line_items_params[:quantities]
      li_quantities_json.each do |product_id, quantity|
        @order.line_items <<
          LineItem.new(sellable: Product.find(product_id), quantity: quantity)
      end
    end

  end
end
