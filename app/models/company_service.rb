class CompanyService < ActiveRecord::Base
  belongs_to :company
  belongs_to :service_type

  def self.companies(ids)
    ServiceType.where("company_id IN (?)",ids).order("name")
  end

  def self.create_new_service_types
  	CompanyService.all.each do |cs|     
        if cs.service_type
          nst = ServiceType.new(:company_id =>cs.company_id,:name => cs.service_type.name,:code =>cs.service_type.code,:kms => cs.service_type.kms,:days => cs.service_type.days,:old_id => cs.service_type.id)
          nst.save
          update_sql = <<-eos
          	INSERT INTO material_service_types(
          			material_id,
          			old_service_type_id,
          			service_type_id,
          			created_at,
          			updated_at
          		)
          		SELECT 
          			material_id,
          			#{cs.service_type.id},
          			#{nst.id},
          			created_at,
          			updated_at          		
          		FROM material_service_types
          		WHERE service_type_id = #{cs.service_type.id}          	
          eos
          ActiveRecord::Base.connection.execute(update_sql)
        end
    end

  end

  def self.create_materials
    Company.headquarters.each do |c|
    	sql_str = <<-eos 
    		INSERT INTO materials (code,prov_code,name,category_id,sub_category_id,created_at,updated_at,brand,provider,company_id,old_id)
					SELECT code,prov_code,name,category_id,sub_category_id,created_at,updated_at,brand,provider,#{c.id},id
					FROM   materials
					WHERE  company_id is null
			eos
			ActiveRecord::Base.connection.execute(sql_str)
    end
  end

  
end
