module OpCart
  class Customer < ActiveRecord::Base
    has_many :cards
    belongs_to :default_card, class_name: 'OpCart::Card'
    belongs_to :user

    before_validation :create_customer, on: :create
    before_validation :update_customer, on: :update

    validates :processor_token, uniqueness: true, presence: true
    validates :user, presence: true

    def processor_object
      @processor_object ||= Stripe::Customer.retrieve processor_token
    end

    def update_card token
      processor_object.card = token
      processor_object.save
      if card = cards.find_by(fingerprint: processor_object.cards.first.try(:fingerprint))
        card.update_attribute :processor_token, processor_object.default_card
      else
        card = cards.create processor_token: processor_object.default_card
      end
      update_attribute :default_card, card
    end

    private

    def create_customer
      if processor_token
        update_customer
      else
        self.processor_token = Stripe::Customer.create(email: user.email).id
      end
    end

    def update_customer
      self.delinquent = processor_object.delinquent
      processor_object.save email: user.email,
        default_card: default_card.try(:processor_token)
      self.default_card ||= Card.find_by processor_token: processor_object.default_card
    end
  end
end
