Rails.application.routes.draw do
  resources :datasets, only: [:index, :show, :new, :create, :destroy] do
    post :assign, on: :member
    post :remove, on: :member
  end

  resources :decisions, only: [:index, :show, :update] do
    get :next, on: :collection
    get :previous, on: :collection
    get :done, on: :collection
  end

  devise_for :users

  root 'datasets#index'
end
