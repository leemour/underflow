Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  concern :commentable do
    resources :comments, except: [:show, :index]
  end

  concern :voteable do
    post 'vote/up', to: 'votes#up'
    post 'vote/down', to: 'votes#down'
    resources :votes, only: [:index]
  end

  %w[faq help].each do |page|
    get page, to: "static##{page}", as: page
  end

  resources :questions do
    concerns :commentable, :voteable
    resources :answers, except: [:show, :index] do
      patch 'accept', on: :member
    end
    resource :bounty, only: [:create, :destroy]
    get 'favor', on: :member
    collection do
      get 'unanswered', to: 'questions#index', scope: 'unanswered'
      get 'most-voted', to: 'questions#index', scope: 'most_voted'
      get 'featured',   to: 'questions#index', scope: 'featured'
      get 'popular',    to: 'questions#index', scope: 'popular'
    end
  end

  resources :answers, only: [] do
    concerns :commentable, :voteable
  end

  resources :users, only: [:index, :show, :edit, :update] do
    get 'questions', to: 'questions#by_user', as: 'questions'
    get 'answers', to: 'answers#by_user', as: 'answers'
    get 'voted/questions', to: 'questions#voted'
    get 'voted/answers', to: 'answers#voted'
    get 'favorite/questions', to: 'questions#favorite'
  end

  resources :tags, only: [:index, :show]
end
