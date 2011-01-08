class CrearCompanyServices < ActiveRecord::Migration
  def self.up
    create_table :company_services do |t|
      t.references :company
      t.references :service_type
    end
    add_foreign_key(:company_services,:companies)
    add_foreign_key(:company_services,:service_types)
  end

  def self.down
    drop_table :company_services 
  end
end
