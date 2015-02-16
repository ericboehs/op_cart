module OpCart
  class PlansController < ApplicationController
    decorates_assigned :plans if defined? decorates_assigned

    def index
      @plans = Plan.purchasable
    end
  end
end
