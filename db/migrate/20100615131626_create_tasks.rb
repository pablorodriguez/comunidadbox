class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.text :description
      t.string :name
      t.timestamps
    end

    create_table :service_types_tasks, :id => false  do |t|
      t.references :service_type
      t.references :task
    end
    
    create_table :services_tasks, :id => false  do |t|
      t.references :service
      t.references :task
    end
    add_index "service_types_tasks", "service_type_id"
    add_index "service_types_tasks", "task_id"    
    
    add_foreign_key(:service_types_tasks,:service_types,:dependent => :delete)
    add_foreign_key(:service_types_tasks,:tasks,:dependent => :delete)
    
    add_foreign_key(:services_tasks,:services)
    add_foreign_key(:services_tasks,:tasks)
  end

  def self.down
    drop_table :tasks
    drop_table :service_types_tasks
    drop_table :services_tasks
  end
end

