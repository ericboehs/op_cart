class CreateOpCartOrders < ActiveRecord::Migration
  def change
    create_table :op_cart_orders do |t|
      t.string :card_token,            null: false
      t.integer :total,                null: false
      t.integer :tax_amount,        default: 0
      t.string :status,                null: false
      t.references :shipping_address, index: true, null: false
      t.references :user, index: true, null: false

      t.timestamps null: false
    end
  end
end
