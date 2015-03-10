module OpCart
  class LineItem < ActiveRecord::Base
    belongs_to :sellable, polymorphic: true
    belongs_to :order

    validates :unit_price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :sellable_snapshot, presence: true
    validates :sellable, presence: true
    # validates :order, presence: true

    before_validation :set_unit_price
    before_validation :snapshot_sellable

    scope :products, -> { where sellable_type: 'OpCart::Product' }
    scope :plans, -> { where sellable_type: 'OpCart::Plan' }

    def total
      if sellable.is_a? Plan
        0
      else
        (unit_price || sellable.price) * quantity
      end
    end

    private
    def set_unit_price
      self.unit_price = sellable.price
    end

    def snapshot_sellable
      self.sellable_snapshot = sellable.attributes
    end
  end
end
