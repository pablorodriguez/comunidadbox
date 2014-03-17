class Export < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  has_many :export_items, :dependent => :destroy 
  
  attr_accessible :status

  before_create :initial_status

  private
  def initial_status
  	export_root = Rails.root.to_s + '/export/' + self.company.id.to_s + "/"

  	self.status = Status::WAITING

  	workOrders = ExportItem.new
  	workOrders.file_name = 'workorders.csv'
  	workOrders.file_path = export_root
  	workOrders.data_type = 'work_orders'

  	self.export_items << workOrders
  end
end
