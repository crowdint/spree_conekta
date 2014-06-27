Spree::Core::Engine.routes.draw do
  namespace :conekta do
    resources :payments, only: [:create, :show]
    resources :credit_cards
  end
end
