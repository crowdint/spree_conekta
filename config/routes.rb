Spree::Core::Engine.routes.draw do
  namespace :conekta do
    resource :payments, only: [:create]
  end
end
