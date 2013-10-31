class CreateItemServiceRequests < ActiveRecord::Migration
  def change
    create_table :item_service_requests do |t|
      t.integer :service_request_id
      t.integer :service_type_id
      t.text :description
      t.date :date_from
      t.date :date_to
      t.float :price

      t.timestamps
    end
  end
end
