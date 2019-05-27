Rails.application.routes.draw do
  root "static_pages#home"
  get  '/home', to: 'static_pages#home'
  get  '/top', to: 'static_pages#top'
  get  '/score/:id', to: 'static_pages#score'
  get  '/questions', to: 'static_pages#question'

  
  get 'news/index'
  get 'news/show'
  get 'news/new'
  get 'news/edit'

  get 'calendar/show'


  # quiz-path
  get '/quiz_index', to: 'quizzes#index'
  get '/quiz_play' , to: 'quizzes#show'
  get '/new_quiz' , to: 'quizzes#new'
  # form_with model: @~~~ に対応するpathは ~~~(複数形、method: post)、それに合わせてやる
  post '/quizzes' , to: 'quizzes#create'
  get '/quiz_title_index' ,to:'quizzes#quiz_title_index'
  get '/edit_quiz_index' , to: 'quizzes#edit_quiz_index'
  get '/edit_quiz/:id', to:'quizzes#edit', as: 'edit_quiz'
  post '/quiz' , to: 'quizzes#update'
  patch '/quiz' , to: 'quizzes#update'
  delete '/delete_quiz/:id' , to: 'quizzes#delete', as: 'delete_quiz'

  post 'score_record/create'
  get '/score_board', to:'score_record#index'
  get 'score_record/show'

  # get 'mistake/index'
  # get 'mistake/show'


  get  '/talks' , to:'talks#index'
  post '/talks' , to:'talks#create'
  get '/edit_talk/:id', to:'talks#edit',as:'edit_talk'
  patch '/talks' , to: 'talks#update'
  delete '/delete_talk/:id', to:'talks#delete',as: 'delete_talk'

  get '/calendar', to:'calendar#show'
  
 

  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: "users/registrations",
    confirmations: "users/confirmations",
    sessions: "users/sessions",
    passwords: "users/passwords",
    unlocks: "users/unlocks"
  }

  # devise/~~~ をadmins/~~~に変える
  #   devise_for :admins, controllers: {
  #   sessions:      'admins/sessions',
  #   passwords:     'admins/passwords',
  #   registrations: 'admins/registrations'
  # }


  # devise_for :admins, only: [:session] do
  # get '/admins/sign_in', :to => 'admins/sessions#new', :as => :new_admin_session
  # post 'admins/sign_in', :to =>'admins/sessions#create',:as => :admin_session
  # delete '/admins/', :to => 'admins/sessions#destroy', :as => :destroy_admin_session
  # end

#   全てのroutesを無効にしてから、必要なものだけを設定
  devise_for :admins, skip: :all
  devise_scope :admin do
  # loginリクエストに対してadmins/sessionsコントローラのnewアクションにルーティングし、new_user_session_pathと名付ける
  get '/admins/sign_in' => 'admins/sessions#new', as: 'new_admin_session'
  post '/admins/sign_in' => 'admins/sessions#create', as: 'admin_session'
  delete '/admins/sign_out' => 'admins/sessions#destroy', as: 'destroy_admin_session'
end

# deviseのroutesをカスタマイズで追加する
  # devise_scope :user do
  #   get '/users_index' => 'users/registrations#index'
  # end

  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
