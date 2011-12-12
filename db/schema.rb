# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111209184911) do

  create_table "addresses", :force => true do |t|
    t.integer  "state_id"
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "city"
    t.string   "street"
    t.string   "zip"
    t.string   "name"
    t.string   "lat"
    t.string   "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["company_id"], :name => "addresses_company_id_fk"
  add_index "addresses", ["state_id"], :name => "addresses_state_id_fk"
  add_index "addresses", ["user_id"], :name => "addresses_user_id_fk"

  create_table "alarms", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "time"
    t.string   "time_unit"
    t.string   "status"
    t.datetime "date_ini"
    t.datetime "date_end"
    t.datetime "date_alarm"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alarms", ["user_id"], :name => "alarms_user_id_fk"

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bdrb_job_queues", :force => true do |t|
    t.text     "args"
    t.string   "worker_name"
    t.string   "worker_method"
    t.string   "job_key"
    t.integer  "taken"
    t.integer  "finished"
    t.integer  "timeout"
    t.integer  "priority"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.string   "tag"
    t.string   "submitter_info"
    t.string   "runner_info"
    t.string   "worker_key"
    t.datetime "scheduled_at"
  end

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "budgets", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.integer  "creator_id"
    t.string   "email"
    t.integer  "brand_id"
    t.integer  "model_id"
    t.string   "domain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.integer  "car_id"
    t.integer  "user_id"
  end

  add_index "budgets", ["car_id"], :name => "budgets_car_id_fk"
  add_index "budgets", ["company_id"], :name => "budgets_company_id_fk"
  add_index "budgets", ["user_id"], :name => "budgets_user_id_fk"

  create_table "car_service_offers", :force => true do |t|
    t.integer  "car_id"
    t.integer  "service_offer_id"
    t.integer  "service_id"
    t.integer  "status"
    t.string   "status_old"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "car_service_offers", ["car_id"], :name => "car_service_offers_car_id_fk"
  add_index "car_service_offers", ["service_id"], :name => "car_service_offers_idfk_3"
  add_index "car_service_offers", ["service_offer_id"], :name => "car_service_offers_service_offer_id_fk"

  create_table "cars", :force => true do |t|
    t.string   "domain"
    t.integer  "model_id"
    t.integer  "brand_id"
    t.integer  "year"
    t.integer  "km"
    t.integer  "kmAverageMonthly"
    t.boolean  "public"
    t.integer  "user_id"
    t.string   "fuel"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cars", ["brand_id"], :name => "cars_brand_id_fk"
  add_index "cars", ["model_id"], :name => "cars_model_id_fk"
  add_index "cars", ["user_id"], :name => "cars_user_id_fk"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.integer  "user_id"
    t.string   "phone"
    t.string   "website"
    t.string   "cuit",       :limit => 13
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["country_id"], :name => "companies_country_id_fk"
  add_index "companies", ["user_id"], :name => "companies_user_id_fk"

  create_table "companies_users", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "company_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company_services", :force => true do |t|
    t.integer "company_id"
    t.integer "service_type_id"
  end

  add_index "company_services", ["company_id"], :name => "company_services_company_id_fk"
  add_index "company_services", ["service_type_id"], :name => "company_services_service_type_id_fk"

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "events", :force => true do |t|
    t.integer  "car_id"
    t.integer  "service_type_id"
    t.integer  "service_id"
    t.integer  "service_done_id"
    t.integer  "km"
    t.integer  "status"
    t.date     "dueDate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["service_id"], :name => "events_service_id_fk"

  create_table "guests", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "domain"
    t.string   "brand"
    t.string   "model"
    t.integer  "km"
    t.integer  "kmavg"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year"
  end

  create_table "material_details", :id => false, :force => true do |t|
    t.integer "material_id",                             :default => 0, :null => false
    t.integer "category_id"
    t.integer "sub_category_id"
    t.integer "service_type_id"
    t.integer "price_list_id",                           :default => 0, :null => false
    t.integer "material_service_type_id",                :default => 0, :null => false
    t.float   "price"
    t.string  "detail_upper",             :limit => 308
    t.string  "detail",                   :limit => 308
    t.integer "company_id"
  end

  create_table "material_service_types", :force => true do |t|
    t.integer  "material_id"
    t.integer  "service_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "material_service_types", ["material_id"], :name => "material_service_types_material_id_fk"
  add_index "material_service_types", ["service_type_id"], :name => "index_material_service_types_on_service_type_id"

  create_table "material_services", :force => true do |t|
    t.integer  "service_id"
    t.integer  "amount"
    t.float    "price"
    t.string   "material"
    t.integer  "material_service_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "material_services", ["material_service_type_id"], :name => "material_services_material_service_type_id_fk"
  add_index "material_services", ["service_id"], :name => "material_services_service_id_fk"

  create_table "materials", :force => true do |t|
    t.string   "code",            :limit => 50
    t.string   "prov_code",       :limit => 50
    t.string   "name"
    t.integer  "category_id"
    t.integer  "sub_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "models", :force => true do |t|
    t.string   "name"
    t.integer  "brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "models", ["brand_id"], :name => "models_brand_id_fk"

  create_table "notes", :force => true do |t|
    t.text     "message"
    t.datetime "due_date"
    t.datetime "recall"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "status"
    t.integer  "user_id"
    t.integer  "workorder_id"
    t.integer  "note_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id",   :null => false
    t.integer  "budget_id"
  end

  add_index "notes", ["budget_id"], :name => "notes_budget_id_fk"
  add_index "notes", ["note_id"], :name => "notes_note_id_fk"
  add_index "notes", ["user_id"], :name => "notes_user_id_fk"
  add_index "notes", ["workorder_id"], :name => "notes_workorder_id_fk"

  create_table "payment_methods", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "price_list_items", :force => true do |t|
    t.integer  "price_list_id"
    t.integer  "material_service_type_id"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "price_list_items", ["material_service_type_id"], :name => "price_list_items_material_service_type_id_fk"
  add_index "price_list_items", ["price_list_id"], :name => "price_list_items_price_list_id_fk"

  create_table "price_lists", :force => true do |t|
    t.string   "name"
    t.boolean  "active"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ranks", :force => true do |t|
    t.integer  "type_rank"
    t.text     "comment"
    t.integer  "cal"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "workorder_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "detail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_filters", :force => true do |t|
    t.string   "fuel"
    t.integer  "year"
    t.string   "city"
    t.string   "name"
    t.integer  "service_type_id"
    t.integer  "model_id"
    t.integer  "brand_id"
    t.integer  "state_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "service_filters", ["brand_id"], :name => "service_filters_brand_id_fk"
  add_index "service_filters", ["model_id"], :name => "service_filters_model_id_fk"
  add_index "service_filters", ["service_type_id"], :name => "service_filters_service_type_id_fk"
  add_index "service_filters", ["state_id"], :name => "service_filters_state_id_fk"
  add_index "service_filters", ["user_id"], :name => "service_filters_user_id_fk"

  create_table "service_offers", :force => true do |t|
    t.float    "price"
    t.float    "final_price"
    t.float    "discount"
    t.float    "percent"
    t.string   "status_old"
    t.integer  "status"
    t.date     "since"
    t.date     "until"
    t.boolean  "monday",          :default => false
    t.boolean  "tuesday",         :default => false
    t.boolean  "wednesday",       :default => false
    t.boolean  "thursday",        :default => false
    t.boolean  "friday",          :default => false
    t.boolean  "saturday",        :default => false
    t.boolean  "sunday",          :default => false
    t.text     "comment"
    t.integer  "service_type_id"
    t.integer  "company_id"
    t.date     "send_at"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "service_offers", ["company_id"], :name => "service_offers_company_id_fk"
  add_index "service_offers", ["service_type_id"], :name => "service_offers_service_type_id_fk"

  create_table "service_types", :force => true do |t|
    t.string   "name"
    t.integer  "kms"
    t.integer  "parent_id"
    t.string   "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_types_tasks", :id => false, :force => true do |t|
    t.integer "service_type_id"
    t.integer "task_id"
  end

  add_index "service_types_tasks", ["service_type_id"], :name => "index_service_types_tasks_on_service_type_id"
  add_index "service_types_tasks", ["task_id"], :name => "index_service_types_tasks_on_task_id"

  create_table "services", :force => true do |t|
    t.string   "comment"
    t.integer  "workorder_id"
    t.integer  "service_type_id"
    t.string   "material",        :limit => 250
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
    t.integer  "operator_id"
    t.integer  "budget_id"
  end

  add_index "services", ["budget_id"], :name => "services_budget_id_fk"
  add_index "services", ["operator_id"], :name => "services_operator_id_fk"
  add_index "services", ["service_type_id"], :name => "services_service_type_id_fk"
  add_index "services", ["workorder_id"], :name => "services_workorder_id_fk"

  create_table "services_tasks", :id => false, :force => true do |t|
    t.integer "service_id"
    t.integer "task_id"
  end

  add_index "services_tasks", ["service_id"], :name => "services_tasks_service_id_fk"
  add_index "services_tasks", ["task_id"], :name => "services_tasks_task_id_fk"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "states", :force => true do |t|
    t.integer  "country_id"
    t.string   "short_name"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "states", ["country_id"], :name => "states_country_id_fk"

  create_table "tasks", :force => true do |t|
    t.text     "description"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_addresses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "address_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["role_id"], :name => "user_roles_role_id_fk"
  add_index "user_roles", ["user_id"], :name => "user_roles_user_id_fk"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone",                :limit => 15
    t.integer  "employer_id"
    t.integer  "creator_id"
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_name"
    t.string   "cuit"
    t.boolean  "confirmed"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["employer_id"], :name => "users_employer_id_fk"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "workorders", :force => true do |t|
    t.text     "comment"
    t.integer  "company_id"
    t.integer  "car_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "km"
    t.date     "performed"
    t.integer  "status"
    t.integer  "payment_method_id"
    t.string   "company_info"
  end

  add_index "workorders", ["car_id"], :name => "workorders_car_id_fk"
  add_index "workorders", ["company_id"], :name => "workorders_company_id_fk"
  add_index "workorders", ["payment_method_id"], :name => "workorders_payment_method_id_fk"
  add_index "workorders", ["user_id"], :name => "workorders_user_id_fk"

  add_foreign_key "addresses", "companies", :name => "addresses_ibfk_1"
  add_foreign_key "addresses", "states", :name => "addresses_ibfk_2"
  add_foreign_key "addresses", "users", :name => "addresses_ibfk_3"

  add_foreign_key "alarms", "users", :name => "alarms_ibfk_1", :dependent => :delete

  add_foreign_key "budgets", "cars", :name => "budgets_car_id_fk", :dependent => :delete
  add_foreign_key "budgets", "companies", :name => "budgets_company_id_fk", :dependent => :delete
  add_foreign_key "budgets", "users", :name => "budgets_user_id_fk"

  add_foreign_key "car_service_offers", "cars", :name => "car_service_offers_ibfk_1", :dependent => :delete
  add_foreign_key "car_service_offers", "service_offers", :name => "car_service_offers_ibfk_2", :dependent => :delete
  add_foreign_key "car_service_offers", "services", :name => "car_service_offers_idfk_3", :dependent => :nullify

  add_foreign_key "cars", "brands", :name => "cars_ibfk_1"
  add_foreign_key "cars", "models", :name => "cars_ibfk_2"
  add_foreign_key "cars", "users", :name => "cars_ibfk_3", :dependent => :delete

  add_foreign_key "companies", "countries", :name => "companies_ibfk_1"
  add_foreign_key "companies", "users", :name => "companies_ibfk_2"

  add_foreign_key "company_services", "companies", :name => "company_services_ibfk_1"
  add_foreign_key "company_services", "service_types", :name => "company_services_ibfk_2"

  add_foreign_key "events", "services", :name => "events_ibfk_122", :dependent => :delete

  add_foreign_key "material_service_types", "materials", :name => "material_service_types_ibfk_1"
  add_foreign_key "material_service_types", "service_types", :name => "material_service_types_ibfk_2"

  add_foreign_key "material_services", "material_service_types", :name => "material_services_ibfk_1"
  add_foreign_key "material_services", "services", :name => "material_services_ibfk_2", :dependent => :delete

  add_foreign_key "models", "brands", :name => "models_ibfk_1"

  add_foreign_key "notes", "budgets", :name => "notes_budget_id_fk", :dependent => :delete
  add_foreign_key "notes", "notes", :name => "notes_note_id_fk", :dependent => :delete
  add_foreign_key "notes", "users", :name => "notes_user_id_fk", :dependent => :delete
  add_foreign_key "notes", "workorders", :name => "notes_workorder_id_fk", :dependent => :delete

  add_foreign_key "price_list_items", "material_service_types", :name => "price_list_items_ibfk_1"
  add_foreign_key "price_list_items", "price_lists", :name => "price_list_items_ibfk_2", :dependent => :delete

  add_foreign_key "service_filters", "brands", :name => "service_filters_ibfk_1", :dependent => :delete
  add_foreign_key "service_filters", "models", :name => "service_filters_ibfk_2", :dependent => :delete
  add_foreign_key "service_filters", "service_types", :name => "service_filters_ibfk_3", :dependent => :delete
  add_foreign_key "service_filters", "states", :name => "service_filters_ibfk_4", :dependent => :delete
  add_foreign_key "service_filters", "users", :name => "service_filters_ibfk_5", :dependent => :delete

  add_foreign_key "service_offers", "companies", :name => "service_offers_ibfk_1"
  add_foreign_key "service_offers", "service_types", :name => "service_offers_ibfk_2"

  add_foreign_key "service_types_tasks", "service_types", :name => "service_types_tasks_ibfk_1", :dependent => :delete
  add_foreign_key "service_types_tasks", "tasks", :name => "service_types_tasks_ibfk_2", :dependent => :delete

  add_foreign_key "services", "budgets", :name => "services_budget_id_fk", :dependent => :delete
  add_foreign_key "services", "service_types", :name => "services_ibfk_1"
  add_foreign_key "services", "users", :name => "services_operator_id_fk", :column => "operator_id"
  add_foreign_key "services", "workorders", :name => "services_ibfk_2", :dependent => :delete

  add_foreign_key "services_tasks", "services", :name => "services_tasks_ibfk_1"
  add_foreign_key "services_tasks", "tasks", :name => "services_tasks_ibfk_2"

  add_foreign_key "states", "countries", :name => "states_ibfk_1", :dependent => :delete

  add_foreign_key "user_roles", "roles", :name => "user_roles_ibfk_1", :dependent => :delete
  add_foreign_key "user_roles", "users", :name => "user_roles_ibfk_2", :dependent => :delete

  add_foreign_key "users", "companies", :name => "users_ibfk_1", :column => "employer_id"

  add_foreign_key "workorders", "cars", :name => "workorders_ibfk_1"
  add_foreign_key "workorders", "companies", :name => "workorders_ibfk_2"
  add_foreign_key "workorders", "payment_methods", :name => "workorders_payment_method_id_fk"
  add_foreign_key "workorders", "users", :name => "workorders_ibfk_3"

end
