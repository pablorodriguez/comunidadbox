class AddCompanyToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :company_id, :integer
    add_foreign_key(:notes,:companies)

    Note.all.each do |note|
      note.company_id = note.creator.company_id
      note.save
    end
  end


end
