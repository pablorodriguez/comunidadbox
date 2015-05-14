class CreateModelsCompaniesJoinTable < ActiveRecord::Migration
  def change
    create_table :companies_models, id: false do |t|
      t.integer :company_id
      t.integer :model_id
    end
  end
end
