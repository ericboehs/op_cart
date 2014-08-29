class CreateOpCartLineItems < ActiveRecord::Migration
  def change
    create_table :op_cart_line_items do |t|
      t.integer    :unit_price,                               null: false
      t.integer    :quantity,                                 null: false
      t.hstore     :sellable_snapshot,                        null: false
      t.references :sellable, polymorphic: true, index: true, null: false
      t.references :order, index: true,                       null: false

      t.timestamps null: false
    end
  end
end
