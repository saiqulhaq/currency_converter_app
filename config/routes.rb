Rails.application.routes.draw do
  root to: 'pages#root'

  namespace :api do
    resource :rates, only: [] do
      collection do
        get :historical
        get :live
      end
    end
  end
end
