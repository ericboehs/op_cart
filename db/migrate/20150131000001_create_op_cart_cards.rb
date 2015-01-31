class CreateOpCartCards < ActiveRecord::Migration
  def change
    create_table :op_cart_cards do |t|
      t.string :processor_token, index: true
      t.string :fingerprint, index: true
      t.string :last4
      t.string :brand
      t.string :exp_month
      t.string :exp_year
      t.references :customer, index: true

      t.timestamps null: false
    end
  end
end
