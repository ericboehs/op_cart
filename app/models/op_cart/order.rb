module OpCart
  class Order < ActiveRecord::Base
    belongs_to :user

    validates :total, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :tax_amount, numericality:
      { only_integer: true, greater_than_or_equal_to: 0 } if :tax_amount?
    validates :status, presence: true
    validates :user, presence: true
  end
end
