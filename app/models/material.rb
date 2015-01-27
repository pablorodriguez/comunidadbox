class Material < ActiveRecord::Base
  attr_accessible :prov_code, :code, :name, :brand, :provider

  has_many :material_service_type
  has_many :service_types, :through => :material_service_type
 
  validates_presence_of :code, :name
  validates_uniqueness_of :code
  validates_uniqueness_of :prov_code,:if => Proc.new { |material| not material.prov_code.empty? }
  validates_format_of :code, :with => /^\D{2}\d{5}/
  
  belongs_to :category
  belongs_to :sub_category,:class_name => 'Category', :foreign_key => 'sub_category_id'
  belongs_to :company
  
  def self.all_materials(price_list)
    comp_id = price_list.company_id
    comp_service_type = Company.find(comp_id).service_types #CompanyService.where("company_id = ?",comp_id)
    service_types_ids = comp_service_type.map(&:service_type_id)
    all_materials = MaterialService.where("material_service_types.service_type_id in (?)",service_types_ids,
        :include=>{:material_service_type =>{:service_type=>{}}})
    all_materials
  end
  
  def detail
    "#{name} #{brand}"    
  end

  def total_services
    Service.joins(:material_services => :material_service_type).where("material_service_types.material_id = ?",self.id).count("material_service_types.material_id")
  end

  def destroy_or_disable
    
    Material.transaction do
      mst = MaterialServiceType.where("material_id = ?",self.id).first
      if mst
        ms = MaterialService.where("material_service_type_id = ?",mst.id)
        if ms
          self.disable = true
          self.save
          self.errors[:base] = "El material no se puede borrar por que fue utilizado en Ordenes de Trabajo, fue solamente deshabiliatdo"
        else
          mst.destroy
          self.destroy
        end
      else
        self.destroy
      end
    end

  end

  def self.has_for_company?(company_id)
    Material.where("company_id = ?",company_id).count > 0
  end

  def self.find_by_params params
    params.delete_if {|k,v| v.empty?}

    page = params[:page] || 1
    
    material = Material.order(:name)
    material = material.where("materials.company_id = ?",params[:company_id]) if params[:company_id]
    material = material.where("code LIKE ?","%#{params[:code]}%") if params[:code]
    material = material.where("name LIKE ?","%#{params[:name]}%") if params[:name]
    material = material.where("brand LIKE ?","%#{params[:brand]}%") if params[:brand]
    material = material.where("provider LIKE ?","%#{params[:provider]}%") if params[:provider]
    
    if params[:service_type_ids]
      material = material.includes(:material_service_type).where("material_service_types.service_type_id IN (?)",params[:service_type_ids]) 
    end

    material = material.paginate(:per_page => 50, :page => page, :order=>'name')
    material
  end

  
  def self.create_material(prov_code,code,name,brand,provider)
    # creo el material
    m = Material.new
    m.prov_code = prov_code
    m.code = code
    m.name = name
    m.brand = brand
    m.provider = privider
    m.save
    m
  end

  def self.to_csv(company_id)
    materials = Material.where("company_id = ?",company_id).order(:name)

    CSV.generate do |csv|
      csv << ['id', 'codigo', 'codigo proveedor', 'nombre', 'marca','provider']
      materials.each do |m|        
        csv << [m.id,m.code,m.prov_code,m.name,m.brand,m.provider]
      end
    end
  end

  def self.from_csv(file,company_id,service_type_ids=[])
    service_type_ids ||=[]
    result = {:updates =>0,:new =>0,:errors_count =>0}

    CSV.foreach(file.path, headers: true) do |row|
      row[0] = row[0] ? row[0].strip : ""
      action = :updates

      if row[0].empty?
        m = Material.new
        m.company_id = company_id
        action = :new
      else
        m = Material.where("id = ? && company_id = ?",row[0].to_i,company_id).first
      end
      
      if m

        m.code = row[1]
        m.prov_code = row[2]
        m.name = row[3]
        m.brand = row[4]
        m.provider = row[5]


        Material.transaction do
          if m.valid?
            m.save
            result[action] += 1
          else
            result[:errors_count] += 1
          end

          service_type_ids.each do |st|
            mst = MaterialServiceType.where("company_id = ? and material_id = ? and service_type_id = ?",company_id,m.id,st.to_i).first
            unless mst
              mst = MaterialServiceType.new(:company_id => company_id,:material_id => m.id,:service_type_id => st.to_i)
              mst.save
            end
          end
        end
      end

      result

    end    
  end



end
