class CreateOpCartShippingAddresses < ActiveRecord::Migration
  def change
    create_table :op_cart_shipping_addresses do |t|
      t.string :full_name,          null: false
      t.string :street,             null: false
      t.string :street_2
      t.string :locality,           null: false
      t.string :region,             null: false
      t.string :postal_code,        null: false
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
