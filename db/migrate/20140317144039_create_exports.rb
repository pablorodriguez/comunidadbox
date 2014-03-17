class CreateExports < ActiveRecord::Migration
  def change
    create_table :exports do |t|
      t.references :user
      t.references :company
      t.integer :status

      t.timestamps
    end
    add_index :exports, :user_id
    add_index :exports, :company_id
    add_foreign_key(:exports,:users)
    add_foreign_key(:exports,:companies)
  end
end
