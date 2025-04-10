Rails.application.routes.draw do
  devise_for :users
  root to: "homes#top"
  get  'home/about', to: 'homes#about', as: 'about'
  get "search" => "searches#search"
  get 'message/:id' => 'messages#show', as: 'message'

  resources :books, only: [:index, :show, :edit, :create, :update, :destroy] do
    resource :favorite, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  
  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    get "search" => "users#search"
  end

  # メッセージ用
  resources :messages, only: [:create]

  # グループ用
  resources :groups, only: [:new, :index, :show, :edit, :create, :update, :destroy] do
    resource :group_users, only: [:create, :destroy]
    get "new/mail" => "groups#new_mail"     # メール用
    get "send/mail" => "groups#send_mail"   # メール用
  end
  
end