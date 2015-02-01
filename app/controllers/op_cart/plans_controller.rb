module OpCart
  class PlansController < ApplicationController
    def index
      @plans = Plan.purchasable
    end
  end
end
