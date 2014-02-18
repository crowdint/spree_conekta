Deface::Override.new(virtual_path: 'spree/checkout/_payment',
                     name: 'conekta_scripts',
                     insert_after: '[data-hook="buttons"]',
                     partial: 'spree/checkout/conekta_scripts')
