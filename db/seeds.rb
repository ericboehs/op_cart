product1_attrs = {
             name: 'Device 3000',
      description: 'The original Device 3000',
              sku: 'A1000',
            price: 15000,
  allow_purchases: true,
     charge_taxes: true,
             user: User.first,
}

product1 = OpCart::Product.where(sku: product1_attrs[:sku]).first_or_create product1_attrs

product2_attrs = {
             name: 'Device 9000',
      description: 'The much improved Device 9000',
              sku: 'A2000',
            price: 25000,
  allow_purchases: true,
     charge_taxes: true,
             user: User.first,
}

product2 = OpCart::Product.where(sku: product2_attrs[:sku]).first_or_create product2_attrs

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

plan1 = OpCart::Plan.where(name: plan1_attrs[:name]).first_or_create plan1_attrs

plan_addon1_attrs = {
  recurring: false,
  product: product1,
  plan: plan1,
  user: User.first,
}

plan_addon1 = OpCart::PlanAddon.first_or_create plan_addon1_attrs
