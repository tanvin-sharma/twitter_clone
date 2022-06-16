Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "tweets#index"
  resource :tweets
  resource :users  
  namespace :api do 
    resources :users, only: %i[index show create update destroy]
    resources :tweets, only: %i[index show create update destroy]
    resources :likes, only: %i[index show create update destroy]
    resources :comments, only: %i[create update destroy]
    resources :follows
  end
end
