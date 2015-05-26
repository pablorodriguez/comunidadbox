class AddCloseSystem < ActiveRecord::Migration
  def change
    add_column :users, :close_system, :boolean
  end

end
