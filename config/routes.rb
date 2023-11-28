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
  get "minhas_reservas", to: "bookings#my_bookings", as: "my_bookings"

  resources :addresses, only: [:new, :create]

  resources :inns, only: [:new, :create, :show, :edit, :update] do
    patch "change_status", on: :member
    get "search", on: :collection
    get "city_search", on: :collection
    get "advanced_search", on: :collection
    delete "remove_photo", on: :member

    resources :reviews, only: [:index]
  end

  resources :rooms, only: [:index, :new, :create, :show, :edit, :update] do
    patch "change_status", on: :member

    resources :seasonal_prices, only: [:new, :create]

    resources :bookings, only: [:new, :create] do
      get "confirmation", on: :collection
      post "cancel", on: :member
      post "check_in", on: :member
      post "check_out", on: :member
    end
  end

  resources :bookings, only: [:index, :show] do
    get "active", on: :collection

    resources :reviews, only: [:new, :create] do
      post "answer", on: :member
    end
  end

  resources :seasonal_prices, only: [:show, :edit, :update, :destroy]

  resources :reviews, only: [:index]

  namespace :api do
    namespace :v1 do
      resources :inns, only: [:index, :show] do
        resources :rooms, only: [:index]
        get "cities", on: :collection
      end

      resources :bookings, only: [] do
        get "pre-booking", on: :collection
      end
    end
  end
end
