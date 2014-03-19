class Export < ActiveRecord::Base
  include Statused 

  belongs_to :user
  belongs_to :company
  has_many :export_items, :dependent => :destroy 
  
  attr_accessible :status

  before_create :initial_status

  #after_update :run_export 

  def run_export
    self.export_items.each do |item| 
      if item.workorders?
        Workorder.to_csv(item.file_path + item.file_name, self.company.id)
      elsif item.customers?
        Company.clients_to_csv(item.file_path + item.file_name, self.company.id)
      elsif item.budgets?
        Budget.to_csv(item.file_path + item.file_name, self.company.id)
      end
    end
    
  end  


  private
  def initial_status
  	export_root = Rails.root.to_s + '/export/' + self.company.id.to_s + "/"

  	self.status = Status::WAITING

  	self.export_items << create_detail(export_root, :workorders)
    self.export_items << create_detail(export_root, :customers)
    self.export_items << create_detail(export_root, :budgets)
  end

  def create_detail(dir_path, data_type)
    export_item = ExportItem.new
    export_item.file_path = dir_path
    export_item.data_type = data_type
    export_item.file_name = data_type.to_s + '.csv'

    export_item    
  end

end
