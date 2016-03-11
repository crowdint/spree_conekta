# Spree Conekta
[![Code Climate](https://codeclimate.com/github/AgilTec/spree_conekta.png)](https://codeclimate.com/github/AgilTec/spree_conekta)
[![Build Status](https://travis-ci.org/AgilTec/spree_conekta.png?branch=2.4.0.rc3)](https://travis-ci.org/AgilTec/spree_conekta)
[![Gem Version](https://badge.fury.io/rb/spree_conekta.png)](http://badge.fury.io/rb/spree_conekta)

Setup
-----

Add this extension to your Gemfile:

```ruby
gem 'spree_conekta', github: 'conekta/spree_conekta', branch: '3-0-stable'
```

Then run:

```
bundle
rails g spree_conekta:install
```

##Setup Conekta Payments

1. You need to go to [Conekta](https://www.conekta.io/), create an account and retrieve your private and public api keys.

2. On the spree application admin side go to:
```
/admin/payment_methods/new
```

3. In the provider box,choose one of the following options depending on your needs:

        Spree::BillingIntegration::ConektaGateway::Card

        Spree::BillingIntegration::ConektaGateway::Cash

        Spree::BillingIntegration::ConektaGateway::Bank

        Spree::BillingIntegration::ConektaGateway::MonthlyPayment

4. On the auth token field, add your Conekta private key.
5. On the public auth token field, add your Conekta public private key.

###Source Methods

Conekta currently supports four different methods:

####Card
>Card method will let you pay using your credit or debit card. More info: [Conekta Card](https://www.conekta.io/es/docs/tutoriales/pagos-con-tarjeta)

####Cash
>Cash method will generate a bar code with the order information so you'll be able to take it to your nearest OXXO store to pay it. More info: [Conekta Cash](https://www.conekta.io/es/docs/tutoriales/pagos-en-efectivo)

####Bank
>Bank method will let you generate a deposit or transfer reference. More info: [Conekta Bank](https://www.conekta.io/es/docs/tutoriales/pago-con-transferencia)

####Monthly Payment
>This method will let you pay using your credit card with a monthly payment schema. More info: [Conekta Monthly Payments](https://admin.conekta.io/es/docs/tutoriales/meses-sin-intereses)
You can configurate the options for number of installements and default creating an initializer in your app and writing code as this example:
```ruby
  Spree::Conekta.configure do |config|
    config.installment_options = [3] # [3, 6] , [3, 6, 12]
    config.installment_default = 3 # 6 12
  end
```

**Important Note:** If you want to support all source methods, you'll need to create a payment method for each one.

**Important Note:** This extension only works with ruby 2.0+.

# About the Author

[Crowd Interactive](http://www.crowdint.com) is an American web design and development company that happens to work in Colima, Mexico.
We specialize in building and growing online retail stores. We don’t work with everyone – just companies we believe in. Call us today to see if there’s a fit.

## Contributors
  * Jonathan Garay
  * Fernando Cuauhtemoc Barajas Chavez
  * Herman Moreno
  * Edwin Cruz
  * Carlos A. Muñiz Moreno
  * Chalo Fernandez
  * Guillermo Siliceo
  * Jaime Victoria
  * Jorge Pardiñas
  * Juan Carlos Rojas
  * Leo Fischer
  * Manuel Vidaurre
  * Marco Medina
  * Mumo Carlos
  * Sergio Morales
  * Steven Barragan
  * Ulices Barajas
  * bishma-stornelli