class ChangeDataTypeForCodProvider < ActiveRecord::Migration
  def up
  	change_table :material_requests do |t|
      t.change :cod_provider, :string
     end
  end
  def down
  	change_table :material_requests do |t|
      t.change :cod_provider, :string
    end
  end
end
