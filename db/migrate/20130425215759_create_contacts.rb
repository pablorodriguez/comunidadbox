class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :from
      t.string :name
      t.text :message

      t.timestamps
    end
  end
end
