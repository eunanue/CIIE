Rails.application.routes.draw do
  resources :configurations, only: [:edit, :update]

  get 'evaluations/report'
  resources :evaluations, only: [:index, :edit, :update]

  authenticated :user do
    root 'papers#index', as: :authenticated_root
  end

  root to: 'home#index'

  get 'home/index_en'
  get 'home/index'
  get 'locales/toggle'

  get 'contribution_type/get_url'

  get 'papers/report'
  resources :papers

  devise_for :users

  get 'users/search'
  resources :users do ||
    post :impersonate, on: :member
    post :stop_impersonating, on: :collection
  end

  get 'papers/search'
end
