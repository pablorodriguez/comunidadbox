class CreateServiceRequests < ActiveRecord::Migration
  def change
    create_table :service_requests do |t|
      t.integer :user_id
      t.integer :car_id
      t.integer :status
      t.integer :company_id

      t.timestamps
    end
  end
end
