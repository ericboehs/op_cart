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
