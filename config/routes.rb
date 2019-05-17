Rails.application.routes.draw do
  get 'news/index'

  get 'news/show'

  get 'news/new'

  get 'news/edit'

  get 'calendar/show'

  get 'talk/index'

  get 'talk/show'

  get 'quizzes/show'
  get 'quizzes/new'
  get 'quizzes/index'
  resources :quizzes
  

  post 'score_record/create'
  get '/score_board', to:'score_record#index'
  get 'score_record/show'

  get 'mistake/index'
  get 'mistake/show'

  get '/talk' , to:'talk#index'
  get  '/create_talk' , to:'talk#index'
  post '/create_talk' , to:'talk#create'

  get '/calendar', to:'calendar#show'
  
 


  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root "static_pages#home"
  get  '/home', to: 'static_pages#home'
  get  '/score/:id', to: 'static_pages#score'

  get  '/questions', to: 'static_pages#question'

 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
