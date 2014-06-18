Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}

  devise_scope :user do
    get 'users/enter-email', to: 'registrations#enter_email',
      as: 'enter_registration_email'
    post 'users/sign_up_with_email', to: 'registrations#sign_up_with_email',
      as: 'sign_up_with_email'
  end

  root 'questions#index'

  concern :pageable do
    get 'page/:page', action: 'index', on: :collection
  end

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
    concerns :pageable, :commentable, :voteable
    resources :answers, except: [:show, :index] do
      patch 'accept', on: :member
    end
    collection do
      get 'unanswered(/page/:page)', to: 'questions#index', scope: 'unanswered',
          as: 'unanswered'
      get 'most-voted(/page/:page)', to: 'questions#index', scope: 'most_voted',
          as: 'most_voted'
      get 'featured(/page/:page)',   to: 'questions#index', scope: 'featured',
          as: 'featured'
      get 'popular(/page/:page)',    to: 'questions#index', scope: 'popular',
          as: 'popular'
    end
    resource :bounty, only: [:create, :destroy]
    get 'favor', on: :member
  end

  resources :answers, only: [] do
    concerns :commentable, :voteable
  end

  resources :users, only: [:index, :show, :edit, :update] do
    concerns :pageable
    get 'questions(/page/:page)',          to: 'questions#by_user',
      as: 'questions'
    get 'answers(/page/:page)',            to: 'answers#by_user',
      as: 'answers'
    get 'voted/questions(/page/:page)',    to: 'questions#voted',
      as: 'voted_questions'
    get 'voted/answers(/page/:page)',      to: 'answers#voted',
      as: 'voted_answers'
    get 'favorite/questions(/page/:page)', to: 'questions#favorite',
      as: 'favorite_questions'
  end

  resources :tags, only: [:index, :show] do
    concerns :pageable
    get 'questions(/page/:page)',          to: 'questions#tagged',
      as: 'questions'
  end
end
