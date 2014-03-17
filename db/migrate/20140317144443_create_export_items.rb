class CreateExportItems < ActiveRecord::Migration
  def change
    create_table :export_items do |t|
      t.references :export
      t.string :data_type
      t.string :file_path
      t.string :file_name

      t.timestamps
    end
    add_index :export_items, :export_id
    add_foreign_key(:export_items,:exports)
  end
end
