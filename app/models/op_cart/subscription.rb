module OpCart
  class Subscription < ActiveRecord::Base
    belongs_to :plan
    belongs_to :order
    belongs_to :customer

    before_validation -> { self.status = :pending }, unless: :status?
    before_validation -> { self.quantity = 1 }, unless: :quantity?
    before_validation :create_subscription, on: :create
    before_validation :update_subscription, on: :update

    validates :processor_token, uniqueness: true, presence: true
    validates :status, presence: true
    validates :quantity, numericality: { only_integer: true, greater_than: 0 }
    validates :started_at, presence: true
    validates :plan, :order, :customer, presence: true

    def processor_object
      @processor_object ||= customer.processor_object.subscriptions.retrieve processor_token
    rescue Stripe::InvalidRequestError => e
      raise e unless e.message.include? 'does not have subscription'
    end

    private

    def create_subscription
      subscriptions_attributes = { plan: plan.processor_token, quantity: quantity }
      subscriptions_attributes[:trial_end] = trial_ended_at.to_i if trial_ended_at
      update_local_object customer.processor_object.subscriptions.create(subscriptions_attributes)
    rescue Stripe::InvalidRequestError => e
      if e.param
        self.errors.add e.param, e.message
      else
        self.errors.add :base, e.message
      end
      false
    end

    def update_subscription
      subscriptions_attributes = {}
      subscriptions_attributes[:quantity] = quantity if quantity_changed?
      subscriptions_attributes[:trial_end] = trial_ended_at.to_i if trial_ended_at_changed?
      subscriptions_attributes[:plan] = plan.processor_token if plan_id_changed?
      update_local_object customer.processor_object.subscriptions.create(subscriptions_attributes)
    rescue Stripe::InvalidRequestError => e
      if e.param
        self.errors.add e.param, e.message
      else
        self.errors.add :base, e.message
      end
      false
    end

    def update_local_object subscription=processor_object
      self.processor_token = subscription.id
      self.status = subscription.status
      self.quantity = subscription.quantity
      self.started_at = Time.at subscription.start
      self.canceled_at = Time.at subscription.canceled_at if subscription.canceled_at
      self.ended_at = Time.at subscription.ended_at if subscription.ended_at
      self.trial_started_at = Time.at subscription.trial_start if subscription.trial_start
      self.trial_ended_at = Time.at subscription.trial_end if subscription.trial_end
      self.plan = Plan.find_by! processor_token: subscription.plan.id
    end
  end
end
