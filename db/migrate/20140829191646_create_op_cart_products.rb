class CreateOpCartProducts < ActiveRecord::Migration
  def change
    create_table :op_cart_products do |t|
      t.string :name,                null: false
      t.text :description,           null: false
      t.string :sku
      t.string :image_url
      t.integer :price,              null: false
      t.boolean :allow_purchases, default: false
      t.boolean :charge_taxes,    default: false
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
