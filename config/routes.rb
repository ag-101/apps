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
            get 'process_response', :on => :member
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

  root :to => 'homes#index'
  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}
  
  get '*url/' => 'apps#route', format: false
end
