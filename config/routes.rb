Spree::Core::Engine.add_routes do
  namespace :conekta do
    resources :payments, only: [:create, :show]
  end
end
