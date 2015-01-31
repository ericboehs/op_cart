module OpCart
  class Order < ActiveRecord::Base
    has_many :line_items
    belongs_to :shipping_address
    belongs_to :user

    attr_accessor :processor_token
    accepts_nested_attributes_for :line_items

    validates :total, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :tax_amount, numericality:
      { only_integer: true, greater_than_or_equal_to: 0 }, if: :tax_amount?
    validates :status, presence: true
    validates :user, presence: true

    before_validation :set_total
    before_validation -> { self.status = :new }, unless: :status?
    before_save :charge_customer

    private

    def set_total
      self.total = line_items.reduce(0) { |total, line_item| total += line_item.total }
    end

    def charge_customer
      customer = Customer.find_or_create_by user: user
      customer.update_card processor_token

      # TODO Create shipping address

      charge = Stripe::Charge.create(
        amount: total,
        currency: "usd",
        customer: customer.processor_token
      )
      #TODO: Mark order as charged
      # update_attribute :charged, true if charge.captured
    rescue Stripe::CardError => e
      # The card has been declined or some other error has occurred
      self.errors.add e
    end
  end
end
