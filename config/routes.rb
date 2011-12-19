SampleApp::Application.routes.draw do 

  get "invite/index"

  #resources :surveys

  #get "surveys/index"

  get "surveys/new"

  get "surveys/create"

  get "sessions/new"

  #match "surveys/index", :to => "surveys#index"

  match "surveys/:id/show", :to => "surveys#show"
  
  match "surveys/:id/review", :to => "surveys#review"

   match "surveys/update_multiple", :to => "surveys#update_multiple"

   match "surveys/:id/submitsurvey", :to => "surveys#submitsurvey"


  resources :users
  resources :sessions, :only => [:new,:create,:destroy]

  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'

  match '/signup',  :to => 'pages#home'
  match '/signin',  :to => 'sessions#authenticateSF'
  match '/signout',  :to => 'sessions#destroy'
  
  match '/auth/:provider/callback', :to => 'sessions#create'
  #match '/auth/:provider/callback' => 'sessions#createOmniauthSF'
  match '/auth/failure', :to => 'sessions#fail'
  
  root :to => 'pages#home'
  
  
end
