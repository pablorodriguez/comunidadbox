class MaterialRequest < ActiveRecord::Base
  attr_accessible :cod_provider, :description, :provider, :state, :trademark, :message, :service_type_id, :user_id, :company_id, :details
  include Statused  

  validates_presence_of :provider, :description, :trademark, :service_type_id, :details

  belongs_to :user
  belongs_to :company
  belongs_to :service_type

  default_scope {order("material_requests.created_at DESC")}
  after_initialize :init


  def code
    material_code = Material.where("code like ?","NM%").last
    if material_code.nil?
      code = NM00000
    else
     code = material_code.code.succ
   end
  end
  def is_open?
    state == Status::OPEN
  end
  def is_approved?
    state == Status::APPROVED
  end
  def is_rejected?
    state == Status::REJECTED
  end

  private
    def init
      self.state = Status::OPEN unless self.state
    end
end


