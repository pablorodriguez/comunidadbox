class ChangeDataTypeForState < ActiveRecord::Migration
  def up
  	change_table :material_requests do |t|
      t.change :status, :integer
     end
  end

  def down
  	change_table :material_requests do |t|
      t.change :status, :integer
    end
  end
end
