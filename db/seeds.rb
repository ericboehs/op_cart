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
