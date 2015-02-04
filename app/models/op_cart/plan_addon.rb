module OpCart
  class PlanAddon < ActiveRecord::Base
    belongs_to :plan
    belongs_to :product
    belongs_to :user
  end
end
