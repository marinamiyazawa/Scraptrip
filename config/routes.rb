Rails.application.routes.draw do
  get 'clips/create'
  get 'clips/destroy'
  # User
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

  root 'homes#top'
  get 'homes/about', to: 'homes#about'
  get '/post/hashtag/:name', to: "posts#hashtag"
  get 'searchs/search', to: 'searches#search'
  resources :vision_images, only: [:new, :create, :show]
  resources :relationships, only: [:create, :destroy]
  resources :users, only: [:show, :edit, :update] do
    member do
      get :hide
      patch :hide_update
      get :following, :followers
    end
  end
  resources :genres, only: [:show]
  resources :messages, :only => [:create]
  resources :rooms, :only => [:create, :show, :index]
  resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    resource :clips, only: [:create, :destroy]
    collection do
      get 'clips'
      get 'ranking'
      get 'get_genre_children', defaults: { format: 'json' }
    end
    resource :favorites, only: [:create, :destroy]
  end

  # Admin
  devise_for :admins
  namespace :admins do
    root "homes#top"
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:index, :show, :edit, :update, :destroy] do
      collection do
        get 'genre_children', defaults: { format: 'json' }
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
