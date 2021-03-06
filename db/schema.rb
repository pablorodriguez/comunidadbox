# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20171011120354) do

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

  create_table "advertisement_days", :force => true do |t|
    t.date     "published_on"
    t.integer  "advertisement_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "advertisement_days", ["advertisement_id"], :name => "advertisement_days_advertisement_id_fk"

  create_table "advertisements", :force => true do |t|
    t.integer  "service_offer_id", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "advertisements", ["service_offer_id"], :name => "advertisements_service_offer_id_fk"

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
    t.boolean  "monday",      :default => false
    t.boolean  "tuesday",     :default => false
    t.boolean  "wednesday",   :default => false
    t.boolean  "thursday",    :default => false
    t.boolean  "friday",      :default => false
    t.boolean  "saturday",    :default => false
    t.boolean  "sunday",      :default => false
    t.boolean  "no_end",      :default => false
    t.datetime "next_time"
    t.datetime "last_time"
    t.integer  "vehicle_id"
    t.integer  "client_id"
    t.integer  "event_id"
    t.integer  "company_id"
  end

  add_index "alarms", ["company_id"], :name => "alarms_company_id_fk"
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
    t.boolean  "of_cars"
    t.boolean  "of_motorcycles"
    t.integer  "company_id"
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
    t.integer  "user_id"
    t.integer  "vehicle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.text     "comment"
    t.string   "vehicle_type"
    t.string   "chassis"
    t.integer  "nro"
    t.datetime "deleted_at"
  end

  add_index "budgets", ["company_id", "nro"], :name => "COMPANY_NRO_UNIQUE_KEY", :unique => true
  add_index "budgets", ["company_id"], :name => "budgets_company_id_fk"
  add_index "budgets", ["deleted_at"], :name => "index_budgets_on_deleted_at"
  add_index "budgets", ["user_id"], :name => "budgets_user_id_fk"
  add_index "budgets", ["vehicle_id"], :name => "budgets_vehicle_id_fk"

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
    t.string   "cuit",        :limit => 13
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo"
    t.boolean  "headquarter"
    t.string   "code"
  end

  add_index "companies", ["country_id"], :name => "companies_country_id_fk"
  add_index "companies", ["user_id"], :name => "companies_user_id_fk"

  create_table "companies_models", :id => false, :force => true do |t|
    t.integer "company_id"
    t.integer "model_id"
  end

  create_table "companies_users", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "company_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies_users", ["company_id"], :name => "companies_users_company_id_fk"
  add_index "companies_users", ["user_id"], :name => "companies_users_user_id_fk"

  create_table "company_attributes", :force => true do |t|
    t.integer  "company_id"
    t.boolean  "material_control"
    t.integer  "budget_nro"
    t.integer  "work_order_nro"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "company_material_codes", :force => true do |t|
    t.string   "code"
    t.integer  "company_id"
    t.integer  "material_service_type_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "company_material_codes", ["company_id"], :name => "index_company_material_codes_on_company_id"
  add_index "company_material_codes", ["material_service_type_id"], :name => "index_company_material_codes_on_material_service_type_id"

  create_table "contacts", :force => true do |t|
    t.string   "from"
    t.string   "name"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
    t.integer  "vehicle_id"
    t.integer  "service_type_id"
    t.integer  "service_id"
    t.integer  "service_done_id"
    t.integer  "km"
    t.integer  "status"
    t.string   "status_o"
    t.date     "dueDate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "events", ["deleted_at"], :name => "index_events_on_deleted_at"
  add_index "events", ["service_id"], :name => "events_service_id_fk"

  create_table "export_items", :force => true do |t|
    t.integer  "export_id"
    t.string   "data_type"
    t.string   "file_path"
    t.string   "file_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "export_items", ["export_id"], :name => "index_export_items_on_export_id"

  create_table "exports", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "exports", ["company_id"], :name => "index_exports_on_company_id"
  add_index "exports", ["user_id"], :name => "index_exports_on_user_id"

  create_table "guests", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "domain"
    t.string   "brand"
    t.string   "model"
    t.integer  "km"
    t.integer  "kmavg"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.string   "image"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "item_service_requests", :force => true do |t|
    t.integer  "service_request_id"
    t.integer  "service_type_id"
    t.text     "description"
    t.date     "date_from"
    t.date     "date_to"
    t.float    "price"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "material_details", :id => false, :force => true do |t|
    t.string  "prov_code",                :limit => 50
    t.integer "material_id",                                                           :default => 0, :null => false
    t.integer "category_id"
    t.integer "sub_category_id"
    t.integer "service_type_id"
    t.integer "price_list_id",                                                         :default => 0, :null => false
    t.integer "material_service_type_id",                                              :default => 0, :null => false
    t.decimal "price",                                  :precision => 10, :scale => 2
    t.text    "detail_upper"
    t.text    "detail"
    t.string  "brand"
    t.string  "provider"
    t.integer "company_id"
  end

  create_table "material_details_old", :id => false, :force => true do |t|
    t.string  "prov_code",                :limit => 50
    t.integer "material_id",                                                            :default => 0, :null => false
    t.integer "category_id"
    t.integer "sub_category_id"
    t.integer "service_type_id"
    t.integer "price_list_id",                                                          :default => 0, :null => false
    t.integer "material_service_type_id",                                               :default => 0, :null => false
    t.decimal "price",                                   :precision => 10, :scale => 2
    t.string  "detail_upper",             :limit => 308
    t.string  "detail",                   :limit => 308
    t.integer "company_id"
  end

  create_table "material_requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "service_type_id"
    t.integer  "material_id"
    t.text     "description"
    t.text     "details"
    t.string   "provider"
    t.string   "cod_provider"
    t.string   "trademark"
    t.string   "message"
    t.integer  "status"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "material_requests", ["company_id"], :name => "index_material_requests_on_company_id"
  add_index "material_requests", ["material_id"], :name => "material_requests_material_id_fk"
  add_index "material_requests", ["service_type_id"], :name => "index_material_requests_on_service_type_id"
  add_index "material_requests", ["user_id"], :name => "index_material_requests_on_user_id"

  create_table "material_service_type_templates", :force => true do |t|
    t.integer  "service_type_template_id"
    t.integer  "material_service_type_id"
    t.string   "material"
    t.integer  "amount"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "material_service_type_templates", ["service_type_template_id"], :name => "material_service_type_templates_service_type_template_id_fk"

  create_table "material_service_types", :force => true do |t|
    t.integer  "material_id"
    t.integer  "service_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.boolean  "protected"
  end

  add_index "material_service_types", ["company_id"], :name => "index_material_service_types_on_company_id"
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
    t.datetime "deleted_at"
  end

  add_index "material_services", ["deleted_at"], :name => "index_material_services_on_deleted_at"
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
    t.string   "brand"
    t.string   "provider"
    t.integer  "company_id"
    t.boolean  "disable"
  end

  add_index "materials", ["code"], :name => "material_code"
  add_index "materials", ["company_id"], :name => "index_materials_on_company_id"
  add_index "materials", ["name"], :name => "material_name"
  add_index "materials", ["prov_code"], :name => "material_prov_code"

  create_table "messages", :force => true do |t|
    t.text     "message"
    t.boolean  "read",                     :default => false
    t.integer  "user_id"
    t.integer  "receiver_id"
    t.integer  "event_id"
    t.integer  "workorder_id"
    t.integer  "budget_id"
    t.integer  "message_id"
    t.integer  "alarm_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "vehicle_service_offer_id"
  end

  add_index "messages", ["alarm_id"], :name => "messages_alarm_id_fk"
  add_index "messages", ["budget_id"], :name => "messages_budget_id_fk"
  add_index "messages", ["event_id"], :name => "messages_event_id_fk"
  add_index "messages", ["message_id"], :name => "messages_message_id_fk"
  add_index "messages", ["user_id"], :name => "messages_user_id_fk"
  add_index "messages", ["vehicle_service_offer_id"], :name => "messages_vehicle_service_offer_id_fk"
  add_index "messages", ["workorder_id"], :name => "messages_workorder_id_fk"

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
    t.string   "status",        :limit => 50
    t.integer  "user_id"
    t.integer  "workorder_id"
    t.integer  "note_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id",                  :null => false
    t.integer  "budget_id"
    t.boolean  "viewed"
    t.integer  "event_id"
    t.integer  "receiver_id"
    t.integer  "respond_to_id"
    t.integer  "alarm_id"
    t.integer  "vehicle_id"
    t.integer  "company_id"
  end

  add_index "notes", ["budget_id"], :name => "notes_budget_id_fk"
  add_index "notes", ["company_id"], :name => "notes_company_id_fk"
  add_index "notes", ["note_id"], :name => "notes_note_id_fk"
  add_index "notes", ["receiver_id"], :name => "notes_receiver_id_fk"
  add_index "notes", ["user_id"], :name => "notes_user_id_fk"
  add_index "notes", ["vehicle_id"], :name => "notes_vehicle_id_fk"
  add_index "notes", ["workorder_id"], :name => "notes_workorder_id_fk"

  create_table "offer_service_types", :force => true do |t|
    t.integer  "service_offer_id"
    t.integer  "service_type_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "offer_service_types", ["service_offer_id"], :name => "offer_service_types_service_offer_id_fk"
  add_index "offer_service_types", ["service_type_id"], :name => "offer_service_types_service_type_id_fk"

  create_table "payment_methods", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.boolean  "active"
  end

  create_table "price_list_items", :force => true do |t|
    t.integer  "price_list_id"
    t.integer  "material_service_type_id"
    t.decimal  "price",                    :precision => 10, :scale => 2
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

  create_table "price_offers", :force => true do |t|
    t.text     "price"
    t.integer  "workorder_id"
    t.integer  "user_id"
    t.boolean  "confirmed",    :default => true
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "price_offers", ["user_id"], :name => "index_price_offers_on_user_id"
  add_index "price_offers", ["workorder_id"], :name => "index_price_offers_on_workorder_id"

  create_table "ranks", :force => true do |t|
    t.integer  "type_rank"
    t.text     "comment"
    t.integer  "cal"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "workorder_id"
  end

  add_index "ranks", ["workorder_id"], :name => "ranks_workorder_id_fk"

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
    t.boolean  "monday",             :default => false
    t.boolean  "tuesday",            :default => false
    t.boolean  "wednesday",          :default => false
    t.boolean  "thursday",           :default => false
    t.boolean  "friday",             :default => false
    t.boolean  "saturday",           :default => false
    t.boolean  "sunday",             :default => false
    t.text     "comment"
    t.integer  "service_type_id"
    t.integer  "company_id"
    t.date     "send_at"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "service_request_id"
  end

  add_index "service_offers", ["company_id"], :name => "service_offers_company_id_fk"
  add_index "service_offers", ["service_request_id"], :name => "service_offers_service_request_id_fk"
  add_index "service_offers", ["service_type_id"], :name => "service_offers_service_type_id_fk"

  create_table "service_requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "vehicle_id"
    t.integer  "status"
    t.integer  "company_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "service_type_templates", :force => true do |t|
    t.string   "name"
    t.integer  "service_type_id"
    t.integer  "company_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "service_type_templates", ["company_id"], :name => "service_type_templates_company_id_fk"
  add_index "service_type_templates", ["service_type_id"], :name => "service_type_templates_service_type_id_fk"

  create_table "service_types", :force => true do |t|
    t.string   "name"
    t.integer  "kms"
    t.integer  "parent_id"
    t.string   "active"
    t.string   "code",       :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "days"
    t.integer  "company_id"
  end

  add_index "service_types", ["company_id"], :name => "index_service_types_on_company_id"

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
    t.string   "material",                 :limit => 250
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
    t.integer  "operator_id"
    t.integer  "budget_id"
    t.integer  "vehicle_service_offer_id"
    t.integer  "status_id"
    t.datetime "deleted_at"
    t.boolean  "warranty"
  end

  add_index "services", ["budget_id"], :name => "services_budget_id_fk"
  add_index "services", ["deleted_at"], :name => "index_services_on_deleted_at"
  add_index "services", ["operator_id"], :name => "services_operator_id_fk"
  add_index "services", ["service_type_id"], :name => "services_service_type_id_fk"
  add_index "services", ["vehicle_service_offer_id"], :name => "services_vehicle_service_offer_id_fk"
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

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.boolean  "is_final"
    t.integer  "company_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "statuses", ["company_id"], :name => "statuses_company_id_fk"

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
    t.string   "phone",                  :limit => 15
    t.integer  "employer_id"
    t.integer  "creator_id"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "password_salt",                         :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_name"
    t.string   "cuit"
    t.boolean  "confirmed"
    t.boolean  "disable"
    t.datetime "reset_password_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                       :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authenticatable"
    t.string   "invitation_token"
    t.integer  "user_type"
    t.string   "external_id"
    t.boolean  "close_system"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["employer_id"], :name => "users_employer_id_fk"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vehicle_service_offers", :force => true do |t|
    t.integer  "vehicle_id"
    t.integer  "service_offer_id"
    t.integer  "service_id"
    t.integer  "status"
    t.string   "status_old"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vehicle_service_offers", ["service_id"], :name => "car_service_offers_idfk_3"
  add_index "vehicle_service_offers", ["service_offer_id"], :name => "car_service_offers_service_offer_id_fk"
  add_index "vehicle_service_offers", ["vehicle_id"], :name => "vehicle_service_offers_vehicle_id_fk"

  create_table "vehicles", :force => true do |t|
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
    t.datetime "kmUpdatedAt"
    t.string   "vehicle_type",     :default => "Car"
    t.string   "chassis"
  end

  add_index "vehicles", ["brand_id"], :name => "cars_brand_id_fk"
  add_index "vehicles", ["model_id"], :name => "cars_model_id_fk"
  add_index "vehicles", ["user_id"], :name => "cars_user_id_fk"
  add_index "vehicles", ["vehicle_type"], :name => "index_vehicles_on_type"

  create_table "workorders", :force => true do |t|
    t.text     "comment"
    t.integer  "company_id"
    t.integer  "vehicle_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "km"
    t.date     "performed"
    t.integer  "status"
    t.integer  "payment_method_id_old"
    t.string   "company_info"
    t.integer  "budget_id"
    t.datetime "deliver"
    t.datetime "deliver_actual"
    t.integer  "status_id"
    t.integer  "payment_method_id"
    t.integer  "nro"
    t.datetime "deleted_at"
  end

  add_index "workorders", ["budget_id"], :name => "workorders_budget_id_fk"
  add_index "workorders", ["company_id", "nro"], :name => "COMPANY__NRO_UNIQUE_KEY", :unique => true
  add_index "workorders", ["company_id"], :name => "workorders_company_id_fk"
  add_index "workorders", ["deleted_at"], :name => "index_workorders_on_deleted_at"
  add_index "workorders", ["payment_method_id_old"], :name => "workorders_payment_method_id_fk"
  add_index "workorders", ["performed"], :name => "workorders_performed_fk"
  add_index "workorders", ["user_id"], :name => "workorders_user_id_fk"
  add_index "workorders", ["vehicle_id"], :name => "workorders_vehicle_id_fk"

  add_foreign_key "addresses", "companies", name: "addresses_ibfk_1", dependent: :delete
  add_foreign_key "addresses", "states", name: "addresses_ibfk_2"
  add_foreign_key "addresses", "users", name: "addresses_ibfk_3", dependent: :delete

  add_foreign_key "advertisement_days", "advertisements", name: "fk_advertisement_days_1", dependent: :delete

  add_foreign_key "advertisements", "service_offers", name: "fk_advertisements_1", dependent: :delete

  add_foreign_key "alarms", "companies", name: "alarms_company_id_fk"
  add_foreign_key "alarms", "users", name: "alarms_ibfk_1", dependent: :delete

  add_foreign_key "budgets", "companies", name: "budgets_company_id_fk", dependent: :delete
  add_foreign_key "budgets", "users", name: "budgets_user_id_fk"
  add_foreign_key "budgets", "vehicles", name: "budgets_vehicle_id_fk", dependent: :delete

  add_foreign_key "companies", "countries", name: "companies_ibfk_1"
  add_foreign_key "companies", "users", name: "companies_ibfk_2"

  add_foreign_key "companies_users", "companies", name: "companies_users_company_id_fk", dependent: :delete
  add_foreign_key "companies_users", "users", name: "companies_users_user_id_fk", dependent: :delete

  add_foreign_key "company_material_codes", "companies", name: "company_material_codes_company_id_fk"
  add_foreign_key "company_material_codes", "material_service_types", name: "company_material_codes_material_service_type_id_fk"

  add_foreign_key "events", "services", name: "events_ibfk_1", dependent: :delete

  add_foreign_key "export_items", "exports", name: "export_items_export_id_fk"

  add_foreign_key "exports", "companies", name: "exports_company_id_fk"
  add_foreign_key "exports", "users", name: "exports_user_id_fk"

  add_foreign_key "material_requests", "companies", name: "material_requests_company_id_fk"
  add_foreign_key "material_requests", "materials", name: "material_requests_material_id_fk"
  add_foreign_key "material_requests", "service_types", name: "material_requests_service_type_id_fk"
  add_foreign_key "material_requests", "users", name: "material_requests_user_id_fk"

  add_foreign_key "material_service_type_templates", "service_type_templates", name: "material_service_type_templates_service_type_template_id_fk", dependent: :delete

  add_foreign_key "material_service_types", "companies", name: "material_service_types_company_id_fk"
  add_foreign_key "material_service_types", "materials", name: "material_service_types_ibfk_1"
  add_foreign_key "material_service_types", "service_types", name: "material_service_types_ibfk_2"

  add_foreign_key "material_services", "material_service_types", name: "material_services_ibfk_1"
  add_foreign_key "material_services", "services", name: "material_services_ibfk_2", dependent: :delete

  add_foreign_key "materials", "companies", name: "materials_company_id_fk"

  add_foreign_key "messages", "alarms", name: "messages_alarm_id_fk", dependent: :delete
  add_foreign_key "messages", "budgets", name: "messages_budget_id_fk", dependent: :delete
  add_foreign_key "messages", "events", name: "messages_event_id_fk", dependent: :delete
  add_foreign_key "messages", "messages", name: "messages_message_id_fk", dependent: :delete
  add_foreign_key "messages", "users", name: "messages_user_id_fk", dependent: :delete
  add_foreign_key "messages", "vehicle_service_offers", name: "messages_vehicle_service_offer_id_fk"
  add_foreign_key "messages", "workorders", name: "messages_workorder_id_fk", dependent: :delete

  add_foreign_key "models", "brands", name: "models_ibfk_1"

  add_foreign_key "notes", "budgets", name: "notes_budget_id_fk", dependent: :delete
  add_foreign_key "notes", "companies", name: "notes_company_id_fk", dependent: :delete
  add_foreign_key "notes", "notes", name: "notes_note_id_fk", dependent: :delete
  add_foreign_key "notes", "users", name: "notes_receiver_id_fk", column: "receiver_id", dependent: :delete
  add_foreign_key "notes", "users", name: "notes_user_id_fk", dependent: :delete
  add_foreign_key "notes", "vehicles", name: "notes_vehicle_id_fk", dependent: :delete
  add_foreign_key "notes", "workorders", name: "notes_workorder_id_fk", dependent: :delete

  add_foreign_key "offer_service_types", "service_offers", name: "offer_service_types_service_offer_id_fk", dependent: :delete
  add_foreign_key "offer_service_types", "service_types", name: "offer_service_types_service_type_id_fk"

  add_foreign_key "price_list_items", "material_service_types", name: "price_list_items_ibfk_1"
  add_foreign_key "price_list_items", "price_lists", name: "price_list_items_ibfk_2", dependent: :delete

  add_foreign_key "price_offers", "users", name: "price_offers_user_id_fk"
  add_foreign_key "price_offers", "workorders", name: "price_offers_workorder_id_fk"

  add_foreign_key "ranks", "workorders", name: "ranks_workorder_id_fk", dependent: :delete

  add_foreign_key "service_filters", "brands", name: "service_filters_ibfk_1", dependent: :delete
  add_foreign_key "service_filters", "models", name: "service_filters_ibfk_2", dependent: :delete
  add_foreign_key "service_filters", "service_types", name: "service_filters_ibfk_3", dependent: :delete
  add_foreign_key "service_filters", "states", name: "service_filters_ibfk_4", dependent: :delete
  add_foreign_key "service_filters", "users", name: "service_filters_ibfk_5", dependent: :delete

  add_foreign_key "service_offers", "companies", name: "service_offers_ibfk_1"
  add_foreign_key "service_offers", "service_requests", name: "service_offers_service_request_id_fk", dependent: :delete
  add_foreign_key "service_offers", "service_types", name: "service_offers_ibfk_2"

  add_foreign_key "service_type_templates", "companies", name: "service_type_templates_company_id_fk", dependent: :delete
  add_foreign_key "service_type_templates", "service_types", name: "service_type_templates_service_type_id_fk"

  add_foreign_key "service_types", "companies", name: "service_types_company_id_fk"

  add_foreign_key "service_types_tasks", "service_types", name: "service_types_tasks_ibfk_1", dependent: :delete
  add_foreign_key "service_types_tasks", "tasks", name: "service_types_tasks_ibfk_2", dependent: :delete

  add_foreign_key "services", "budgets", name: "services_budget_id_fk", dependent: :delete
  add_foreign_key "services", "service_types", name: "services_ibfk_1"
  add_foreign_key "services", "users", name: "services_operator_id_fk", column: "operator_id"
  add_foreign_key "services", "vehicle_service_offers", name: "services_vehicle_service_offer_id_fk"
  add_foreign_key "services", "workorders", name: "services_ibfk_2", dependent: :delete

  add_foreign_key "services_tasks", "services", name: "services_tasks_ibfk_1"
  add_foreign_key "services_tasks", "tasks", name: "services_tasks_ibfk_2"

  add_foreign_key "states", "countries", name: "states_ibfk_1", dependent: :delete

  add_foreign_key "statuses", "companies", name: "statuses_company_id_fk"

  add_foreign_key "user_roles", "roles", name: "user_roles_ibfk_1", dependent: :delete
  add_foreign_key "user_roles", "users", name: "user_roles_ibfk_2", dependent: :delete

  add_foreign_key "users", "companies", name: "users_employer_id_fk", column: "employer_id", dependent: :delete

  add_foreign_key "vehicle_service_offers", "service_offers", name: "vehicle_service_offers_ibfk_2", dependent: :delete
  add_foreign_key "vehicle_service_offers", "services", name: "car_service_offers_idfk_3", dependent: :nullify
  add_foreign_key "vehicle_service_offers", "vehicles", name: "vehicle_service_offers_vehicle_id_fk", dependent: :delete

  add_foreign_key "vehicles", "brands", name: "vehicles_ibfk_1"
  add_foreign_key "vehicles", "models", name: "vehicles_ibfk_2"
  add_foreign_key "vehicles", "users", name: "vehicles_ibfk_3", dependent: :delete

  add_foreign_key "workorders", "budgets", name: "workorders_budget_id_fk", dependent: :delete
  add_foreign_key "workorders", "companies", name: "workorders_company_id_fk", dependent: :delete
  add_foreign_key "workorders", "users", name: "workorders_user_id_fk"
  add_foreign_key "workorders", "vehicles", name: "workorders_vehicle_id_fk"

end
