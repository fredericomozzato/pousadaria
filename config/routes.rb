Rails.application.routes.draw do
  devise_for :owners, path: "owners", controllers: {
    sesions: "owners/sessions",
    registrations: "owners/registrations",
    passwords: "owners/passwords",
    confirmations: "owners/confirmations",
    unlocks: "owner/unlocks"
  }

  root "home#index"
  get "logins", to: "home#logins"

  resources :addresses, only: [:new, :create]
  get "minha_pousada", to: "inns#my_inn"
  resources :inns, only: [:new, :create, :show, :edit, :update] do
    patch "change_status", on: :member
  end
  resources :rooms, only: [:index, :new, :create, :show]
end
