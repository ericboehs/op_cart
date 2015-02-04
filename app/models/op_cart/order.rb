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
    validates :line_items, presence: true
    validates :shipping_address, associated: true
    validates :user, presence: true
    validate :validate_plan_addons_included

    before_validation :set_total
    before_validation -> { self.status = :pending }, unless: :status?
    before_save :charge_customer, if: -> { self.status == 'pending' }

    private

    def set_total
      self.total = line_items.reduce(0) { |total, line_item| total += line_item.total }
    end

    def validate_plan_addons_included
      unless line_items.flat_map do |li|
        if li.sellable.is_a?(Plan) && (addons = li.sellable.plan_addons).present?
          addons.map do |addon|
            addon_li = line_items.select{|pali| pali.sellable == addon.product }
            addon_li.count == 1 && addon_li[0].quantity == li.quantity
          end
        end
      end.compact.all?
        self.errors.add :base, 'Plan addon(s) missing'
      end
    end

    def charge_customer
      customer = Customer.find_or_create_by user: user
      if processor_token.present?
        customer.update_card processor_token
        processor_token = nil
      end

      self.processor_response = Stripe::Charge.create(
        amount: total,
        currency: "usd",
        customer: customer.processor_token
      ).to_hash
      self.status = :paid if processor_response['captured']
    rescue Stripe::InvalidRequestError, Stripe::CardError => e
      if e.try(:code) == 'card_declined'
        self.status = :payment_declined
      end

      self.processor_response = {
        customer_token: customer.processor_token, error: e.json_body
      }

      if e.message.include? "Stripe token more than once"
        message = 'There was a problem with the request. Sorry about that. Try entering your card again.'
      end

      self.errors.add :card_error, (message || e.message)
      false
    end
  end
end
