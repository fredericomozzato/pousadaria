Rails.application.routes.draw do
  devise_for :owners, path: "owners", controllers: {
    sesions: "owners/sessions",
    registrations: "owners/registrations",
    passwords: "owners/passwords",
    confirmations: "owners/confirmations",
    unlocks: "owner/unlocks"
  }

  devise_for :users, path: "users", controllers: {
    sesions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations",
    unlocks: "users/unlocks"
  }


  root "home#index"
  get "logins", to: "home#logins"
  get "minha_pousada", to: "inns#my_inn", as: "my_inn"

  resources :addresses, only: [:new, :create]
  resources :inns, only: [:new, :create, :show, :edit, :update] do
    patch "change_status", on: :member
    get "search", on: :collection
    get "city_search", on: :collection
    get "advanced_search", on: :collection
  end
  resources :rooms, only: [:index, :new, :create, :show, :edit, :update] do
    patch "change_status", on: :member
    resources :seasonal_prices, only: [:new, :create]
    resources :bookings, only: [:new, :create] do
      get "confirmation", on: :collection
    end
  end
  resources :seasonal_prices, only: [:show, :edit, :update, :destroy]
end
