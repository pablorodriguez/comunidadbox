class Export < ActiveRecord::Base
  include Statused 

  belongs_to :user
  belongs_to :company
  has_many :export_items, :dependent => :destroy 
  
  attr_accessible :status,:user,:company

  before_create :initial_status

  after_update :send_notification 

  def run_export
    update_attribute(:status,Status::RUNNING)
    
    self.export_items.each do |item| 
      if item.workorders?
        Workorder.to_csv(item.file_path + item.file_name, self.company.id)
      elsif item.customers?
        Company.clients_to_csv(item.file_path + item.file_name, self.company.id)
      elsif item.budgets?
        Budget.to_csv(item.file_path + item.file_name, self.company.id)
      end
    end
    update_attribute(:status,Status::DONE)        
  end  

  def self.create_for_user user    
    user.export.destroy if user.export.present?
    Export.create(:user => user,:company => user.company_active)
  end

  def self.can_download?(user, export_item_id)
    return false if user.export.blank?

    #la siguiente linea no se por que no funciona
    #user.export.export_item_ids.include? export_item_id

    #esta si funciona :S
    ExportItem.includes(:export => :user).where("users.id = ? and export_items.id=?",user.id,export_item_id).present?

  end

  private
  def initial_status
  	export_root = Rails.root.to_s + '/export/' + self.company.id.to_s + "/"

    FileUtils.mkdir_p(File.dirname(export_root + "/files")) unless File.exist?(File.dirname(export_root + "/files"))

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

  def send_notification
    
    # el metodo is_done? me devuelve false.. aunque el estado sea DONE

    if self.status == Status::DONE
      logger.info "### envio mail de notificacion de archivos csv's generados"    
      
      #corre en backgound
      Resque.enqueue ExportNotifierJob,self.id
      
      #Corre sin encolar
      #ExportNotifier.notify(self).deliver 
    end
  end
end
