class CreateOpCartCustomers < ActiveRecord::Migration
  def change
    create_table :op_cart_customers do |t|
      t.string :processor_token
      t.boolean :delinquent, default: false
      t.references :default_card, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
