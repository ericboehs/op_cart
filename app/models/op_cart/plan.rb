module OpCart
  class Plan < ActiveRecord::Base
    belongs_to :user

    before_validation -> { self.interval_count = 1 }, unless: :interval_count?
    before_create :create_plan
    before_update :update_plan

    validates :processor_token, uniqueness: true, presence: true
    validates :name, :interval, presence: true
    validates :price, :interval_count,
      numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :user, presence: true

    validates :processor_token, :price, :interval_count, :interval,
      unchangeable: true, on: :update

    scope :purchasable, -> { where allow_purchases: true }

    def processor_object
      @processor_object ||= Stripe::Plan.retrieve processor_token
    end

    private

    def create_plan
      Stripe::Plan.create id: processor_token, name: name, amount: price,
        currency: 'usd', interval: interval, interval_count: interval_count,
        trial_period_days: trial_period_days, metadata: {
          description: description, image_url: image_url, creator: user.email }
    rescue Stripe::InvalidRequestError => e
      if e.param
        self.errors.add e.param, e.message
      else
        self.errors.add :base, e.message
      end
      false
    end

    def update_plan
      processor_object.metadata = { description: description,
        image_url: image_url, creator: user.email }
      processor_object.save name: name
    rescue Stripe::InvalidRequestError => e
      if e.param
        self.errors.add e.param, e.message
      else
        self.errors.add :base, e.message
      end
      false
    end
  end
end
