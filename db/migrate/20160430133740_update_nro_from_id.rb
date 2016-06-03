class UpdateNroFromId < ActiveRecord::Migration
  def up
    execute "update budgets set nro = id"
    execute "update workorders set nro = id"
  end

  def down
    execute "update budget set nro = null"
    execute "update workorders set nro= null"
  end
end
