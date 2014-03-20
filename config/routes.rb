SchoolSystem::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users, :controllers => { :registrations => 'registrations'}
  
  resources :parents, :only => [:show] do 
    collection  do
      get "new_student"
      get "ask_question"
      post "create_registration_with_cpf"
      get "add_student"
    end
  end  
  
  resources :schools
  resources :professors, only: :new do
    collection do
      post "show_students"
    end
  end  
    
  put '/monthly_grades' => 'monthly_grades#update_grade', :as => 'update_grade'
  post '/monthly_grades/create_grade' => 'monthly_grades#create_grade'
  
  
  resources :users do
    collection do
      get "new_registration_with_cpf"
      post "create_registration_with_cpf"
      get "signup"
      post "find_parent_or_student_for_signup"
      get "change_student"
      get "change_subjects"
      get "ask_question"
    end
  end
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
   root :to => 'users#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
