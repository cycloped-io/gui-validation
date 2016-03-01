Rails.application.routes.draw do
  resources :datasets, only: [:index, :show, :new, :create, :destroy] do
    post :assign, on: :member
    post :remove, on: :member
    get :split_form, on: :member
    patch :split, on: :member
  end

  resources :decisions, only: [:index, :show, :update] do
    get :next, on: :member
    get :previous, on: :member
    get :done, on: :collection
  end

  devise_for :users

  root 'decisions#index'
end
