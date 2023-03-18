Rails.application.routes.draw do
  root 'home#index'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [:index, :show, :update] do
        member do
          post :follow
          delete :unfollow
          post :clock_in
          post :clock_out
        end
      end
      devise_for :users, skip: [:registrations, :sessions], controllers: {
        registrations: 'api/v1/users/registrations',
        sessions: 'api/v1/users/sessions'
      }
      
      devise_scope :user do
        post 'users/signup', to: 'users/registrations#create'
        post 'users/sign_in', to: 'users/sessions#create'
        delete 'users/sign_out', to: 'users/sessions#destroy'
      end
    end
  end

  devise_for :users, only: []
end