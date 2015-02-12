class CreateOpCartSubscriptions < ActiveRecord::Migration
  def change
    create_table :op_cart_subscriptions do |t|
      t.string :processor_token
      t.string :status
      t.integer :quantity
      t.datetime :started_at
      t.datetime :canceled_at
      t.datetime :ended_at
      t.datetime :trial_started_at
      t.datetime :trial_ended_at
      t.references :plan, index: true
      t.references :order, index: true
      t.references :customer, index: true

      t.timestamps null: false
    end
  end
end
