Spree::Core::Engine.routes.draw do
  namespace :conekta do
    resources :payments, only: [:create, :show]
  end
end
