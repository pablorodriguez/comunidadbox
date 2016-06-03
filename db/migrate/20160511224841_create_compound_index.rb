class CreateCompoundIndex < ActiveRecord::Migration
  def up
    execute "ALTER TABLE workorders ADD UNIQUE KEY `COMPANY__NRO_UNIQUE_KEY` (company_id,nro)"
    execute "ALTER TABLE budgets ADD UNIQUE KEY `COMPANY_NRO_UNIQUE_KEY` (company_id,nro)"
  end

  def down
    execute "ALTER TABLE workorders DROP INDEX 'COMPANY_NRO_UNIQUE_KEY'"
    execute "ALTER TABLE budgets DROP INDEX 'COMPANY_NRO_UNIQUE_KEY'"
  end
end
