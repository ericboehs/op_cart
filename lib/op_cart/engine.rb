module OpCart
  class Engine < ::Rails::Engine
    isolate_namespace OpCart

    initializer "op_cart.url_helpers" do
      ActiveSupport.on_load(:action_controller) do
        helper Rails.application.routes.url_helpers
      end
    end
  end
end
