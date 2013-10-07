# Spree Conekta


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

3. In the provider box, choose: 
```
Spree::BillingIntegration::Conekta
```

4. On the source method field, add the value of one of the following:
  * card
  * cash
  * bank

###Source Methods

Conekta currently supports three different methods:

####Card
>Card method will let you pay using your credit or debit card. More info: [Conekta Card](https://www.conekta.io/docs/crear_cargo#tarjetas)

####Cash
>Cash method will generate a bar code with the order information so you'll be able to take it to your nearest OXXO store to pay it. More info: [Conekta Cash](https://www.conekta.io/docs/crear_cargo#oxxo)

####Bank
>Bank method will let you generate a deposit or transfer reference. More info: [Conekta Bank](https://www.conekta.io/docs/crear_cargo#bancos)


**Important Note:** If you want to support all source methods, you'll need to create a payment method for each one.

# About the Author

[Crowd Interactive](http://www.crowdint.com) is an American web design and development company that happens to work in Colima, Mexico. 
We specialize in building and growing online retail stores. We don’t work with everyone – just companies we believe in. Call us today to see if there’s a fit.

