class CreateOpCartPlanAddons < ActiveRecord::Migration
  def change
    create_table :op_cart_plan_addons do |t|
      t.boolean :recurring
      t.references :plan, index: true
      t.references :product, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
