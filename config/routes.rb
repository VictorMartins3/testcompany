Rails.application.routes.draw do
  resources :participants, only: [ :index, :create ]
  resources :events, only: [ :show, :create ] do
    member do
      get :feedback_report
    end
  end
  resources :talks, only: [ :create ] do
    resources :feedbacks, only: [ :create ]
  end
  resources :attendances, only: [ :create ]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
