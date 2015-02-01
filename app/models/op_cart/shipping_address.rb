module OpCart
  class ShippingAddress < ActiveRecord::Base
    has_many :orders
    belongs_to :user

    validates :full_name, :street, :locality, :region, :postal_code, presence: true
    validates :postal_code, format: { with: /\A\d{5}\z/ }
    validates :user, presence: true
  end
end
