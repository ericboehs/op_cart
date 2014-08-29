module OpCart
  class Product < ActiveRecord::Base
    belongs_to :user

    validates :name, presence: true
    validates :description, presence: true
    validates :sku, uniqueness: true, if: :sku?
    validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :user, presence: true

    scope :purchasable, -> { where allow_purchases: true }
  end
end
