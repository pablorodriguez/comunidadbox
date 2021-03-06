class ServiceFilter < ActiveRecord::Base
  attr_accessible :service_type_id, :state_id, :city, :brand_id, :model_id, :fuel, :year, :date_from, :date_to

  belongs_to :service_type
  belongs_to :brand
  belongs_to :model
  belongs_to :user
  belongs_to :state
  belongs_to :user

  attr_accessor :date_from,:date_to
  
  def description
    desc=""
    unless service_type.nil?
      desc += "Tipo de Servicio: " + service_type.name
    end
    
    unless brand.nil?
      unless desc.blank?
        desc += "<br>"
      end
      desc += "Marca: "+ brand.name          
    end
    
    unless model.nil?
      unless desc.blank?
        desc += "<br>"
      end
      
      desc += "Modelo: " + model.name
    end
    
    unless year.nil?
      unless desc.blank?
        desc += "<br>"
      end
      
      desc +="Ano: " + year.to_s
    end
    
    unless fuel.blank?
      unless desc.blank?
        desc += "<br>"
      end
      
      desc += "Combustible: " +fuel
    end
    
    unless state.blank?
      unless desc.blank?
        desc += "<br>"
      end
      
      desc += "Provincia: " + state.name
    end
    
    unless city.blank?
      unless desc.blank?
        desc += "<br>"
      end
      
      desc += "Ciudad: " + city
    end
    
    desc
  end
end
