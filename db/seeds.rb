shipping_address1_attrs = {
  full_name: User.first.name,
  street: '123 N 4th',
  locality: 'New York',
  region: 'New York',
  postal_code: '12345',
  user: User.first,
}
shipping_address1 = OpCart::ShippingAddress.where(street: shipping_address1_attrs[:street]).first_or_create! shipping_address1_attrs

product1_attrs = {
             name: 'Device 3000',
      description: 'The original Device 3000',
              sku: 'A1000',
            price: 15000,
  allow_purchases: true,
     charge_taxes: true,
             user: User.first,
}
product1 = OpCart::Product.where(sku: product1_attrs[:sku]).first_or_create! product1_attrs

product2_attrs = {
             name: 'Device 9000',
      description: 'The much improved Device 9000',
              sku: 'A2000',
            price: 25000,
  allow_purchases: true,
     charge_taxes: true,
             user: User.first,
}
product2 = OpCart::Product.where(sku: product2_attrs[:sku]).first_or_create! product2_attrs

rand_plan_no = rand 10**9
plan1_attrs = {
  name: "Gold Plan #{rand_plan_no}",
  processor_token: "gold-#{rand_plan_no}",
  interval: 'month',
  interval_count: 1,
  price: '1500',
  description: 'Better than Silver.',
  image_url: 'http://example.com/example.png',
  trial_period_days: 30,
  allow_purchases: true,
  user: User.first,
}
plan1 = OpCart::Plan.where(name: plan1_attrs[:name]).first_or_create! plan1_attrs

plan_addon1_attrs = {
  recurring: false,
  product: product1,
  plan: plan1,
  user: User.first,
}
plan_addon1 = OpCart::PlanAddon.first_or_create! plan_addon1_attrs

token1 = Stripe::Token.create card: { number: '4'+'1'*15, exp_month: 1, exp_year: 2031, cvc: 123 }
order1 = OpCart::Order.first || OpCart::Order.new(user: User.first, shipping_address: shipping_address1, processor_token: token1.id)
order1.line_items << OpCart::LineItem.new(sellable: plan1, quantity: 1)
order1.line_items << OpCart::LineItem.new(sellable: plan_addon1.product, quantity: 1)
order1.save!
