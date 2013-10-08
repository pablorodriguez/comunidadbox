class AddMissedFk < ActiveRecord::Migration
  def up
  	add_foreign_key(:companies_users,:companies)
  	add_foreign_key(:companies_users,:users)
  	add_foreign_key(:ranks,:workorders)
  end

  def down
  end
end
