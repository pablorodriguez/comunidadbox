ComunidadBox::Application.routes.draw do
  
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
  
  match 'auth/:provider/callback' => 'authentications#create'
  match "admin" => "admin#show"
  match "conf" => "conf#show"
  
  devise_for :users,:controllers => { :registrations => "users/registrations" }

  resources :authentications
  resources :service_filters
  resources :states
  resources :countries
  resources :brands
  resources :models
  resources :item_services
  resources :car_filters
  resources :ranks
  resources :tasks
  resources :home
  resources :event
  
  resources :employees do
    collection do
      post :search
    end
    
  end
  
  resources :workorders do
    collection do
      get :filter
    end
    member do
      get :notify
    end
  end
    
 resources :companies do
    collection do
      get :service_types
      get :all
      post :search
      post :add_service_type
      post :remove_service_type
    end
    
    member do
      get :activate
    end
  end
  
  resources :cars do
    collection do
      post :find_models
      post :search
      get :update_km
      post :update_km_avg
      get :my
    end
  end
  
  resources :users do 
    collection do 
      get :new_employee 
      get :list_service_offer
      get :companies
      get :future_events
      post :find_models
    end
  end
  
  resources :alarms do
    collection do
      get :list_alarm_now
      get :send_alarm
    end
  end

  resources :clients do
    collection do
      post :search
    end
  end
  
  resources :services do
    collection do
      post :add_material
      post :add_service
    end
  end

  resources :control_panels do
    collection do
      post :filter_alarms
      post :find_models
      get :filter_alarms
      post :save_filter
    end
  end
  
  resources :service_offers do
    collection do
      post :send_notification
    end
  end

  resources :car_service_offer do
    member do
      get :confirm
      get :reject
    end
  end

  resources :service_types do
    member do
      get :task_list
    end
    collection do
      get :search_sub_category
      put :save_material
      put :destroy_material
      put :save_task
    end
  end
  
  resources :materials do
    collection do
      get :details
      post :save_service_type
      get :destroy_servicetype
    end
  end
  
  resources :price_lists do
    member do
      get :activate
      get :items
      get :copy
      put :update_item_price
    end
    
    collection do
      get :import_price
    end
  end  
  
  root :to => "home#welcome"
  
end

