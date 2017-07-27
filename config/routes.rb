Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :snack_vote, only: [:create, :index]

  root 'snack_vote#index'
end
