SampleApp::Application.routes.draw do 

  #resources :surveys

  get "surveys/index"

  get "surveys/new"

  get "surveys/create"

  get "sessions/new"

  match "surveys/index", :to => "surveys#index"

  match "surveys/:id/show", :to => "surveys#show"
  
  match "surveys/:id/review", :to => "surveys#review"

  #match 'surveys/:id/show' => 'surveys#update_multiple', :as => 'surveys', :via => :post

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
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
