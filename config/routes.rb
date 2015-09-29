Rails.application.routes.draw do
  resources :phone_number_queries, :only => :index
  root 'phone_number_queries#index'
end
