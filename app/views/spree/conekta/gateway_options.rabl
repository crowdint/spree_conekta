object @order

node(:description)  { 'Spree Order' }
node(:amount)       { |order| order.display_total.cents }
node(:currency)     { Spree::Config[:currency] }
node(:reference_id) { |order| order.number }

node :details do |order|
  {
      name: order.name,
      phone: order.bill_address.phone,
      email: order.email,

      billing_address: {
        email:   order.email,
        street1: order.bill_address.address1,
        street2: order.bill_address.address2,
        city:    order.bill_address.city,
        state:   order.bill_address.state,
        country: order.bill_address.country,
        zip:     order.bill_address.zipcode
      },

      line_items: order.line_items.map(&:to_conekta),

      shipment: {
        price: order.shipments.sum(:cost),
        address: {
            street1: order.ship_address.address1,
            street2: order.ship_address.address2,
            city:    order.ship_address.city,
            state:   order.ship_address.state,
            country: order.ship_address.country,
            zip:     order.ship_address.zipcode
        }
      }
  }
end
