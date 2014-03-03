Forms::Application.routes.draw do
  resources :homes
  
  resources :apps do
    scope module: :apps do
      resources :workflows do
        resources :workflow_stages
      end      
      
      match 'submissions_select', to: 'submissions'
      resources :forms do
        resources :submissions do
          resources :workflow_content, :controller =>'workflow_content' do
            get 'approve', :on => :member
            get 'reject', :on => :member
          end
        end
        get 'swap_disabled_status', :on => :member
        get 'publish', :on => :member
        get 'new_submission', :on => :member
        match 'save'
      end
    end
  end
  

  
  get '/roles', to: 'roles#index'
  get '/roles/new', to: 'roles#new'
  
  match '/role/:id/new', to: 'roles#new', as: 'role'
  match '/role/:id', to: 'roles#index_app', as: 'role'
   


  

  devise_for :users

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  
  root :to => 'homes#index'
  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}
  
  get '*url/' => 'apps#route', format: false
end
