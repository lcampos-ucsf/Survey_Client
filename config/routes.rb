SampleApp::Application.routes.draw do 

  #namespace :client do
  resources :surveys do
    get :show
    get :review
    put :update_multiple, :on => :collection
    get :print
    get :printv, :on => :collection
    get :submitsurvey
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
  match '/timedout',  :to => 'sessions#timedout'

  
  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#fail'
  
  root :to => 'pages#home'

end
