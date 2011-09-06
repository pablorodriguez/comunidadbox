class AddCompanyAndOperatorToWorkOrder < ActiveRecord::Migration
  def self.up
     add_column :workorders, :operator_id,:integer
     add_foreign_key(:workorders,:users,:column=>'operator_id')
     add_column :workorders, :company_info,:string
  end

  def self.down
    remove_column :workorders,:operator_id
    remove_column :workorders,:company_info
  end
end
