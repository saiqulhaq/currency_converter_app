Rails.application.routes.draw do
  root to: 'pages#root'

  namespace :api do
    resource :rates, only: [] do
      collection do
        get :history
        get :live
      end
    end
  end
end
