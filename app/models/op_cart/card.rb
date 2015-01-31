module OpCart
  class Card < ActiveRecord::Base
    belongs_to :customer
    before_validation :create_processor_object, on: :create
    before_validation :update_local_object, on: :update

    validates :processor_token, uniqueness: true, presence: true
    validates :fingerprint, :brand, :last4, :exp_month, :exp_year, presence: true
    validates :customer, presence: true

    def processor_object
      @processor_object ||= customer.processor_object.cards.retrieve processor_token
    rescue Stripe::InvalidRequestError => e
      raise e unless e.message.include? 'does not have card'
    end

    private
    def create_processor_object
      if processor_object
        update_local_object
      else
        update_local_object customer.processor_object.cards.create(card: processor_token)
      end
    end

    def update_local_object card=processor_object
      self.fingerprint ||= card.fingerprint
      self.brand ||= card.brand
      self.last4 ||= card.last4
      self.exp_month ||= card.exp_month
      self.exp_year ||= card.exp_year
    end
  end
end
