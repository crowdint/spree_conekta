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
bundle exec rake railties:install:migrations FROM=spree_conekta
bundle exec rake db:migrate
```

Also, you'll need to require the javascript file in your frontend
manifest by adding:

```
//= require spree_conekta
```

Note: We will be adding the install generator soon.

# About the Author

[Crowd Interactive](http://www.crowdint.com) is an American web design and development company that happens to work in Colima, Mexico. 
We specialize in building and growing online retail stores. We don’t work with everyone – just companies we believe in. Call us today to see if there’s a fit.
