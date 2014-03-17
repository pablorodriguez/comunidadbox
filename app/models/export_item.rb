class ExportItem < ActiveRecord::Base
  belongs_to :export
  attr_accessible :data_type, :file_name, :file_path

end
