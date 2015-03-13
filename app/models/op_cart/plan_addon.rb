module OpCart
  class PlanAddon < ActiveRecord::Base
    belongs_to :plan
    belongs_to :product
    belongs_to :user

    scope :purchasable, -> { joins(:product).where op_cart_products: { allow_purchases: true } }
  end
end
