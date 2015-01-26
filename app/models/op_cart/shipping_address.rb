module OpCart
  class ShippingAddress < ActiveRecord::Base
    has_many :orders
    belongs_to :user

    validates :full_name, :street, :locality, :region, :postal_code, presence: true
    validates :user, presence: true
  end
end
