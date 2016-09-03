# encoding: utf-8
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
  match "vgneumaticos"=>"guests#new"

  constraints CanAccessResque do
    mount Resque::Server, at: '/resque'
  end

  scope '(:locale)' do
    devise_for :users,:controllers => { :registrations => "users/registrations",:sessions =>'users/sessions',:confirmations =>"users/confirmations" }
    match "/help" => "help#index"

    resources :company_attributes
    resources :item_service_requests
    resources :service_requests
    resources :guests
    resources :authentications
    resources :service_filters
    resources :states
    resources :countries
    resources :brands
    resources :models do
      collection do
        post :import
      end
    end

    resources :notes
    resources :item_services
    resources :car_filters
    resources :ranks
    resources :tasks
    resources :payment_methods
    resources :service_type_templates
    resources :contacts
    resources :material_requests
    resources :advertising
    resources :statuses
    #resources :company_brands

    resources :messages do
      member do
        get :email
        post :read
      end

      collection do
        get :users
      end
    end

    resources :home do
      collection do
        post :set_company
      end
    end

    resources :messages do
      member do
        post :respond
      end
    end

    resources :events do
      resources :notes
      resources :alarms

      member do
        get :search_notes
      end
    end


    resources :budgets do
      resources :notes
      collection do
        get :export
      end
      member do
        get :print
        get :email
        get :email_s
        put :undelete
      end
    end

    resources :employees do
      collection do
        post :search
      end

      member do
        get :activate
      end

    end

    resources :workorders do
      collection do
        get :filter
        post :task_list
        get :autopart
        get :export
      end
      member do
        get :notify
        get :print
        get :price_offer
        post :save_price_offer
        get :price_offers
        put :confirm_price_offer
        put :undelete
      end
    end

   resources :companies do
      collection do
        get :service_types
        get :all
        get :admin
        post :search
        post :search_distance
        post :add_service_type
        post :remove_service_type
      end

      member do
        get :activate
      end
    end

    resources :vehicles do
      resources :alarms
      resources :notes

      collection do
        get :find_models
        get :find_brands
        post :find_company_models_by_brand
        post :search
        post :search_companies
        get :my
      end

      member do
        put :km
        get :services_done
        get :future_events
        get :report_graph
        get :notes
        get :alarms
        get :messages
      end
    end

    # resources :cars, controller: 'vehicles', type: 'Car' do
    #   resources :alarms
    #   resources :notes

    #   collection do
    #     post :find_models
    #     post :search
    #     post :search_companies
    #     get :my
    #   end

    #   member do
    #     put :km
    #     get :services_done
    #     get :future_events
    #     get :report_graph
    #     get :notes
    #     get :alarms
    #     get :messages
    #   end
    # end

    # resources :motorcycles, controller: 'vehicles', type: 'Motorcycle' do
    #   resources :alarms
    #   resources :notes

    #   collection do
    #     post :find_models
    #     post :search
    #     post :search_companies
    #     get :my
    #   end

    #   member do
    #     put :km
    #     get :services_done
    #     get :future_events
    #     get :report_graph
    #     get :notes
    #     get :alarms
    #     get :messages
    #   end
    # end


    resources :users do
      resources :messages

      collection do
        get :generate_email
        get :validate_email
        get :validate_domain
        get :new_employee
        get :list_service_offer
        get :companies
        get :future_events
        post :find_models
        get :mail_confirmation
        get :reset_password
        get :unlock
      end


    end

    resources :alarms do
      collection do
        get :list_alarm_now
      end
      member do
        get :send_alarm
      end
    end

    resources :clients do
      collection do
        get :search
        get :index_all
        get :export
        get :import
        put :upload
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
        get :filter_alarms
        post :find_models
        post :save_filter
      end
    end

    resources :service_offers do
      collection do
        post :send_notification
        post :new_s
        get :notify_email
        get :notify
      end
      member do
        get :show_ad
      end

    end

    resources :vehicle_service_offers do
      member do
        get :confirm
        get :reject
      end
      collection do
        get :confirmed
      end
    end

    resources :service_types do
      resources :materials do
        member do
          delete :remove
        end
      end

      member do
        get :task_list
        put :add_task
        delete :remove_task
        post :add_material
        get :search_material
      end

      collection do
        get :search_sub_category
        put :destroy_material
      end
    end

    resources :materials do

      resources :service_types do
        member do
          delete :remove
        end
      end
      collection do
        get :details
        get :export
        post :import
      end
    end

    resources :price_lists do
      member do
        get :activate
        get :items
        get :copy
        put :update_item_price
        put :price_upload
        get :export
      end

      collection do
        get :import_price
      end
    end

    resources :material_requests do
      collection do
        post :search
      end
      member do
        get :approved
        get :disapproved
      end
    end

    resources :exports do
      member do
        get :download
        get :run
      end
    end

    resources :company_material_codes do
      collection do
        get :export
        post :import
      end
    end

    #resources :company_brands do
    #  collection do
    #    get :index
    #    post :add_models
    #  end
    #  member do
    #    delete :remove
    #  end
    #end

    root :to => "home#index"

  end

end

