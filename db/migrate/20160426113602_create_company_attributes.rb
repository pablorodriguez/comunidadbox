class CreateCompanyAttributes < ActiveRecord::Migration
  def change
    create_table :company_attributes do |t|
      t.integer :company_id
      t.boolean :material_control
      t.integer :budget_nro
      t.integer :work_order_nro
      t.timestamps
    end
  end
end
