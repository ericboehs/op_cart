class AddCouponToOpCartSubscriptions < ActiveRecord::Migration
  def change
    add_column :op_cart_subscriptions, :coupon, :string
  end
end
