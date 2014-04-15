# Spree Conekta
[![Code Climate](https://codeclimate.com/github/crowdint/spree_conekta.png)](https://codeclimate.com/github/crowdint/spree_conekta)
[![Build Status](https://travis-ci.org/crowdint/spree_conekta.png?branch=conekta-apiv2)](https://travis-ci.org/crowdint/spree_conekta)
[![Gem Version](https://badge.fury.io/rb/spree_conekta.png)](http://badge.fury.io/rb/spree_conekta)

Setup
-----

Add this extension to your Gemfile:

```ruby
gem 'spree_conekta', git: 'git://github.com/crowdint/spree_conekta.git'
```

Then run:

```
bundle
rails g spree_conekta:install
```

##Setup Conekta Payments

1. You need to go to [Conekta](https://www.conekta.io/), create an account and retrieve your public api key.

2. On the spree application admin side go to:
```
/admin/payment_methods/new
```

3. In the provider box,choose one of the following options depending on your needs:

        Spree::BillingIntegration::Conekta::Card

        Spree::BillingIntegration::Conekta::Cash

        Spree::BillingIntegration::Conekta::Bank

4. On the auth token field, add your Conekta public key:

###Source Methods

Conekta currently supports three different methods:

####Card
>Card method will let you pay using your credit or debit card. More info: [Conekta Card](https://www.conekta.io/docs/crear_cargo#tarjetas)

####Cash
>Cash method will generate a bar code with the order information so you'll be able to take it to your nearest OXXO store to pay it. More info: [Conekta Cash](https://www.conekta.io/docs/crear_cargo#oxxo)

####Bank
>Bank method will let you generate a deposit or transfer reference. More info: [Conekta Bank](https://www.conekta.io/docs/crear_cargo#bancos)


**Important Note:** If you want to support all source methods, you'll need to create a payment method for each one.

**Important Note:** This extension only works with ruby 2.0+.

# About the Author

[Crowd Interactive](http://www.crowdint.com) is an American web design and development company that happens to work in Colima, Mexico.
We specialize in building and growing online retail stores. We don’t work with everyone – just companies we believe in. Call us today to see if there’s a fit.
