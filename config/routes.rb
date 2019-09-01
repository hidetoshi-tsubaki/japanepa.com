Rails.application.routes.draw do
  root "static_pages#home"
  get 'users/show'
  get 'users/index'
  get 'comments/create'
  get 'comments/edit'
  get 'comments/delete'
  get 'communities/index'
  get 'communities/create'
  get 'communities/delete'
  get 'communities/update'
  get '/home', to: 'static_pages#home'
  get '/top', to: 'static_pages#top'
  get '/score/:id', to: 'static_pages#score'
  get '/questions', to: 'static_pages#question'
  # resources :comunity

  # get 'calendar/show'

  # quiz-path
  
  # resources :quiz

  get '/quiz_index', to: 'quizzes#index'
  get '/quiz_play', to: 'quizzes#show'
  get '/new_quiz', to: 'quizzes#new'
  # form_with model: @~~~ に対応するpathは ~~~(複数形、method: post)、それに合わせてやる
  post '/quizzes', to: 'quizzes#create'
  get '/quiz_title_index', to: 'quizzes#quiz_title_index'
  get '/edit_quiz_index', to: 'quizzes#edit_quiz_index'
  get '/quiz/:id/edit', to: 'quizzes#edit', as: 'edit_quiz'
  post '/quiz', to: 'quizzes#update'
  patch '/quiz', to: 'quizzes#update'
  delete '/quiz/:id/delete', to: 'quizzes#delete', as: 'delete_quiz'
  get '/quiz_section_list/:id/:page', to: 'quizzes#get_section_list', as: 'quiz_section_list'
  get '/quiz_title_list/:id/:page', to: 'quizzes#get_title_list', as: 'quiz_title_list'
  get '/quizzes_in_title/:id', to: 'quizzes#quizzes_in_title', as: 'quizzes_in_title'
  get '/all_quizzes', to: 'quizzes#all_quizzes'
  get '/all_quizzes_in_level/:id', to: 'quizzes#all_quizzes_in_level'
  get '/all_quizzes_in_section/:id', to: 'quizzes#all_quizzes_in_section'

  get '/category_levels', to: 'quiz_categories#levels'
  get '/quiz_category/new', to: 'quiz_categories#new', as: 'new_parent_quiz_categroy'
  get '/quiz_category/:id/new', to: 'quiz_categories#new_children', as: 'new_children_quiz_categroy'
  post '/quiz_categories', to: 'quiz_categories#create'
  get '/quiz_category/:id/edit', to: 'quiz_categories#edit', as: 'edit_quiz_category'
  patch '/quiz_category/:id', to:'quiz_categories#update'
  delete '/quiz_category/:id/delete',to: 'quiz_categories#delete', as: 'delete_quiz_category'
  patch '/quiz_category/:id/sort', to: 'quiz_categories#sort'

  post 'score_record/create'
  get '/score_record', to: 'score_record#index'
  get '/score_record/show'

  # get '/talks/:id', to: ' talks#index', as: 'talks_index'
  # def index をコメントアウトにしているので、routing errorになる
  # get '/talk/:id', to: 'talks#show', as: 'talk_show'
  get '/create_talk', to: 'talks#new'
  get '/create_talk/:id', to: 'talks#new', as: 'create_talk_from_community'
  post '/talks', to: 'talks#create', as: 'talks'
  get '/edit_talks/:id', to: 'talks#edit', as: 'edit_talks'
  # updateの時のform_withが生成する送り先urlは/talk/
  patch '/talk/:id', to: 'talks#update', as: 'talk'
  delete '/delete_talk/:id', to: 'talks#delete', as: 'delete_talk'
  post '/talks_sort', to: 'talks#sort'
  post '/talks_search', to: 'talks#search'

  get '/comment', to: 'comments#new'
  post '/comments', to: 'comments#create'
  get '/edit_comment/:id', to: 'comments#edit', as: 'edit_comment'
  patch '/comment', to: 'comments#update'
  delete '/delete_comment', to: 'comment#delete'

  get '/articles_index', to: 'araticles#index'
  get '/articles/:id', to: 'articles#show', as: 'show_articles'
  get '/create_articles', to: 'articles#new'
  post '/articles', to: 'articles#create'
  get '/edit_articles/:id', to: 'articles#edit', as: 'edit_articles'
  patch '/article', to: 'articles#update'
  post '/articles/image_upload', to: 'articles#image_upload'
  post '/articles/delete_image', to: 'articles#delete_image'
  delete '/delete_articles/:id', to: 'articles#delete', as: 'delete_article'
  post '/articles_sort', to: 'articles#sort'
  post '/articles_search', to: 'talks#search'

  get '/japanepa/feed', to: 'communities#feed', as: 'feed'
  get '/create_community', to: 'communities#new'
  get '/communities', to: 'communities#index'
  get '/community/:id', to: 'communities#show', as: 'show_community'
  post '/communities', to: 'communities#create'
  get '/community', to: 'communities#edit'
  patch '/community', to: 'communities#update'
  delete '/community', to: 'communities#delete'
  post '/communities_sort', to: 'communities#sort'
  post '/communities_search', to: 'communities#search'
  get '/join_community/:id', to: 'communities_users#join', as: 'join_community'
  get '/leave_community/:id', to: 'communities_users#leave', as: 'leave_community'

  get '/like_talk/:id', to: 'likes_talks#like', as: 'like_talk'
  get '/remove_like_talk/:id', to: 'likes_talks#remove_like', as: 'remove_like_talk'

  get '/like_article/:id', to: 'likes_articles#like', as: 'like_article'
  get '/remove_like_article/:id', to: 'likes_articles#remove_like', as: 'remove_like_article'

  get '/bookmark/:id', to: 'bookmarks#bookmark', as: 'bookmark'
  get '/remove_bookmark/:id', to: 'bookmarks#remove_bookmark', as: 'remove_bookmark'

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

  #   全てのroutesを無効にしてから、必要なものだけを設定
  devise_for :admins, skip: :all
  devise_scope :admin do
    # loginリクエストに対してadmins/sessionsコントローラのnewアクションにルーティングし、new_user_session_pathと名付ける
    get '/admins/sign_in' => 'admins/sessions#new', as: 'new_admin_session'
    post '/admins/sign_in' => 'admins/sessions#create', as: 'admin_session'
    delete '/admins/sign_out' => 'admins/sessions#destroy', as: 'destroy_admin_session'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
