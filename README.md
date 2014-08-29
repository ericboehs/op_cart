## Op(inionated) Cart

_Opinionated cart engine for Ruby on Rails_

OpCart makes things simple through inflexibility and lack of features.

OpCart assumes you are using:
- Stripe for payments
- Rails `~> 4.2.0`
- Postgres `~> 9.3`
- Devise `~> 3.3` for authentication
- ActiveJob with a job queue configured
- SSL already

OpCart assumes you don’t:
- have hundreds of products and want search indexing
- need promotion/coupon support
- need to track inventory
- charge for shipping
- have complex products to sell (e.g. variants like different sizes and colors)
- like Spree or other open-source carts

### Installation

Add `op_cart` to your `Gemfile`:
```
gem 'op_cart', '~> 1.0.0'
```

Copy the migrations and run them:
```
rake op_cart:install:migrations db:migrate
```

Add a `checkout` route to your `config/routes.rb`:
```
Rails.application.routes.draw do
  mount OpCart::Engine => "/store"
  #...
end
```

_When updating OpCart, you will need to run `rake op_cart:install:migrations` again._

### Data Models and Classes
- Product
  - name
  - description
  - image\_url
  - price (in cents)
  - allow\_purchases (to hide product and disable sales)
  - charge\_taxes
  - user\_id (creator)
- Order
  - status
  - total
  - tax\_charge
  - shipping\_address\_id
  - user\_id
- Line Item
  - unit\_price
  - quantity
  - price
  - sellable\_snapshot (object freeze)
  - sellable\_type
  - sellable\_id
  - order\_id
- Payment
- PaymentGateway
- Cart (cookie?)
- Address
- Shipment
- Tax Calculator
