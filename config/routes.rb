SampleApp::Application.routes.draw do 

  get "invite/index"
  get "invite/new"
  get "invite/all"

  match "invite/create", :to => "invite#create"
  match "invite/:id/edit", :to => "invite#edit"
  match "invite/update", :to => "invite#update"

  #resources :surveys

  #get "surveys/index"

  get "surveys/new"

  get "surveys/create"

  get "sessions/new"

  #match "surveys/index", :to => "surveys#index"

  match "surveys/:id/show", :to => "surveys#show"
  match "surveys/:id/review", :to => "surveys#review"
  match "surveys/update_multiple", :to => "surveys#update_multiple"
  match "surveys/autocompletequery", :to => "surveys#autocompletequery"
  match "surveys/:id/submitsurvey", :to => "surveys#submitsurvey"


  resources :sessions, :only => [:new,:create,:destroy]

  match '/home',  :to => 'pages#home'
  match '/invite', :to => 'invite#index'

  match '/signin',  :to => 'sessions#authenticateSF'
  match '/signout',  :to => 'sessions#destroy'
  match '/signoutsf',  :to => 'sessions#signout_revoke'
  match '/signoutexp',  :to => 'sessions#signout_exp'

  
  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#fail'
  
  root :to => 'pages#home'
  
  
end
