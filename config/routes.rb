SampleApp::Application.routes.draw do 


#  get "invite/index"
#  get "invite/new"
#  get "invite/all"
#  get "invite/all_inprogress"
#  get "invite/all_complete"
#  get "invite/stats"

#  match "invite/create", :to => "invite#create"
#  match "invite/:id/edit", :to => "invite#edit"
#  match "invite/update", :to => "invite#update"
#  match "invite/stats_data", :to => "invite#stats_data"
#  match "invite/survey_search", :to => "invite#survey_search"


  #get "sessions/new"

  #namespace :client do
  resources :surveys do
    get :show
    get :review
    put :update_multiple, :on => :collection
    get :print
  end
  #end

  resources :invite, :except => [:show, :update, :destroy] do
    put :update, :on => :collection
    get :all, :on => :collection
    get :all_complete, :on => :collection
    get :all_inprogress, :on => :collection
    get :stats, :on => :collection
    get :survey_search, :on => :collection
    get :stats_data, :on => :collection
  end

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
