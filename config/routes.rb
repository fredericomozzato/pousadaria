Rails.application.routes.draw do
  devise_for :owners, path: "owners"
  devise_for :users

  root "home#index"
end
