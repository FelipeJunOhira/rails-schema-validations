Rails.application.routes.draw do

  namespace :schemas do
    namespace :v2 do
      resources :users do
        post :search, on: :collection
      end
    end
  end

end
