module OpCart
  class LineItem < ActiveRecord::Base
    belongs_to :sellable, polymorphic: true
    belongs_to :order

    validates :unit_price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :sellable_snapshot, presence: true
    validates :sellable, presence: true
    validates :order, presence: true
  end
end
