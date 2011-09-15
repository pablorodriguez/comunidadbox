class AddOperatorToServices < ActiveRecord::Migration
  def self.up
    add_column :services, :operator_id,:integer
    add_foreign_key(:services,:users,:column=>'operator_id')
  end

  def self.down
    remove_column :services,:operator_id
  end
end
