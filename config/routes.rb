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
  resources :mistakes, only: [:index, :destroy] do
    collection do
      get :search
    end
  end
  resources :score_records, only: [:index, :show, :create]
  resources :talks do
    collection do
      get :sort
      get :search
      get :tag_search
    end
    member do
      get :user
    end
  end
  resources :like_talks, only: [:create, :destroy]
  resources :comments
  resources :articles, only: [:show, :index] do
    collection do
      get :sort
      get :search
      get :tag_search
    end
  end
  resources :like_articles, only: [:create, :destroy]
  resources :bookmarks, only: [:index, :create, :destroy]
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
    post 'category_with_experience_forms', to: 'quiz_categories#create'
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
    resources :talks do
      collection do
        get :search
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