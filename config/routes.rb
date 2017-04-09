Rails.application.routes.draw do

  namespace :schemas do
    namespace :v2 do
      resources :users
    end
  end

end
