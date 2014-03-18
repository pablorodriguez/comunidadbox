class ExportItem < ActiveRecord::Base
	extend Enumerize

  belongs_to :export
  attr_accessible :data_type, :file_name, :file_path

  enumerize :data_type, in: [:workorders, :customers, :budgets], predicates: true

  def self.get_file(id)
  	export_item = ExportItem.find_by_id(id)

		if export_item.present? && File.exist?(export_item.file_path + export_item.file_name)
			file = File.open(export_item.file_path + export_item.file_name)
	  else
	  	nil
	  end
	end
end
