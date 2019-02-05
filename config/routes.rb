Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          post :sign_up
          post :login
        end
      end
      resources :lists do
        member do
          get :assing_member
          get :unassing_member
        end
        resources :cards
      end

      resources :cards do
        resources :comments
      end


    end
  end
end
