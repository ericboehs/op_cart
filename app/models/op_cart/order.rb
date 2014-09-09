module OpCart
  class Order < ActiveRecord::Base
    belongs_to :user

    validates :email, presence: true, format: { with: /@/ }
    validates :total, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :tax_amount, numericality:
      { only_integer: true, greater_than_or_equal_to: 0 } if :tax_amount?
    validates :status, presence: true
    validates :user, presence: true

    before_save :charge_customer

    private

    def charge_customer
      # TODO Create and charge customer
    end
  end
end
