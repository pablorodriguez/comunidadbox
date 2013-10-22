class ChangeDataTypeForState < ActiveRecord::Migration
  def up
  	change_table :material_requests do |t|
      t.change :state, :integer
     end
  end

  def down
  	change_table :material_requests do |t|
      t.change :state, :integer
    end
  end
end
