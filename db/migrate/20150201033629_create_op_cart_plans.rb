class CreateOpCartPlans < ActiveRecord::Migration
  def change
    create_table :op_cart_plans do |t|
      t.string :processor_token
      t.string :name, null: false
      t.string :description
      t.string :image_url
      t.integer :price
      t.integer :interval_count
      t.string :interval
      t.integer :trial_period_days
      t.boolean :allow_purchases, default: false
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :op_cart_plans, :users
  end
end
