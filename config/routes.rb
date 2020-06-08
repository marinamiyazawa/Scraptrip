Rails.application.routes.draw do
  devise_for :admins
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'homes#top'
  get 'homes/about', to:'homes#about'

  resources :relationships, only: [:create, :destroy]
  resources :users, only: [:show,:edit,:update] do
                    	member do
                    		get :hide
                    		patch :hide_update
                    		get :following, :followers
                    	end
  end
  resources :messages, :only => [:create]
  resources :rooms, :only => [:create, :show, :index]
  resources :posts, only: [:new,:create,:index,:show,:edit,:update] do
  	resource :favorites, only: [:create, :destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
