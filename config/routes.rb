Rails.application.routes.draw do
  root "static_pages#home"
  get '/', to: 'static_pages#home'
  get '/feed/:id', to: 'static_pages#feed', as: 'feed'

  resources :quizzes, only: [:show, :index] do
    collection do
      get :all_quizzes
    end
    member do
      get :play
      get :play_mistakes
    end
  end
  resources :mistakes, only: [:show, :destroy] do
    collection do
      get :search
    end
  end
  resources :score_records, only: [:index, :show, :create]
  resources :talks, except: :index do
    collection do
      get :sort
      get :search
      get :tag_search
    end
    member do
      get :user
    end
  end
  get '/like_talk/:id', to: 'likes_talks#like', as: 'like_talk'
  get '/remove_like_talk/:id', to: 'likes_talks#remove_like', as: 'remove_like_talk'
  resources :comments
  resources :articles, only: [:show, :index] do
    collection do
      get :sort
      get :search
      get :tag_search
    end
  end
  get '/like_article/:id', to: 'likes_articles#create', as: 'like_article'
  get '/remove_like_article/:id', to: 'likes_articles#destroy', as: 'remove_like_article'
  resources :bookmarks, only: :index
  get '/bookmark/:id', to: 'bookmarks#create', as: 'bookmark'
  get '/remove_bookmark/:id', to: 'bookmarks#destroy', as: 'remove_bookmark'
  resources :communities do
    collection do
      get :sort
      get :search
      get :tag_search
    end
    member do
      get :join
      get :leave
    end
  end

  namespace :admin do
    get '/', to: 'home#top'
    resources :users, only: [:index] do
      collection do
        get :search
      end
    end
    resources :quizzes do
      collection do
        get :all
        get :search
      end
      member do
        get :all_in_level
        get :all_in_section
        get :titles
        get :quizzes_in_title
      end
    end
    get '/quizzes/section_list/:id/:page', to: 'quizzes#get_section_list', as: 'quiz_sections'
    get '/quizzes/title_list/:id/:page', to: 'quizzes#get_title_list', as: 'quiz_titles'
    post 'title_quiz_experience_forms', to: 'quiz_categories#create'
    resources :quiz_categories do
      collection do
        get :levels
        post :create_level
        get :new_level
        get :new_quiz
        get :edit_quiz
        get :new_categroy
        get :search
      end
      member do
        get :new_category
        get :categories
        patch :sort
        get :edit_quiz
        get :new_quiz
      end
    end
    resources :articles do
      collection do
        get :search
        get :tag_search
        post :upload_image
        post :delete_image
      end
    end
    resources :communities do
      collection do
        get :search
        get :tag_search
      end
    end
    resource :user, only: [:index, :delete]
  end

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: "users/registrations",
    confirmations: "users/confirmations",
    sessions: "users/sessions",
    passwords: "users/passwords",
    unlocks: "users/unlocks",
  }

  # deviseのroutesをカスタマイズで追加する
  devise_scope :user do
    get '/users', to: 'users#index', as: 'users'
    get 'user/:id', to: 'users#show', as: 'user'
  end

  # devise/~~~ をadmins/~~~に変える
  #   devise_for :admins, controllers: {
  #   sessions:      'admins/sessions',
  #   passwords:     'admins/passwords',
  #   registrations: 'admins/registrations'
  # }

  # routesをカスタマイズして、追加する
  # devise_for :admins, only: [:session] do
  # get '/admins/sign_in', :to => 'admins/sessions#new', :as => :new_admin_session
  # post 'admins/sign_in', :to =>'admins/sessions#create',:as => :admin_session
  # delete '/admins/', :to => 'admins/sessions#destroy', :as => :destroy_admin_session
  # end

  devise_for :admin, skip: :all
  devise_scope :admin do
    # loginリクエストに対してadmins/sessionsコントローラのnewアクションにルーティングし、new_user_session_pathと名付ける
    get '/admin/sign_in' => 'admin/sessions#new', as: 'new_admin_session'
    post '/admin/sign_in' => 'admin/sessions#create', as: 'admin_session'
    delete '/admin/sign_out' => 'admin/sessions#destroy', as: 'destroy_admin_session'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end