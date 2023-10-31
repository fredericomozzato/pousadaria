Rails.application.routes.draw do
  devise_for :owners, path: "owners", controllers: {
    sesions: "owners/sessions",
    registrations: "owners/registrations",
    passwords: "owners/passwords"
  }
  devise_for :users

  root "home#index"
  get "logins", to: "home#logins"
end
