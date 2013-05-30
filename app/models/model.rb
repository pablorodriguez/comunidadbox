class Model < ActiveRecord::Base
  attr_accessible :brand_id, :name
  
  has_many :cars
  belongs_to :brand
  validates_presence_of :brand

  def self.import(file)
    CSV.foreach(file.path,{:headers =>  true, :col_sep =>"\t"}) do |row|      
      brand = Brand.find_by_name(row["brand"]) || new      
      unless brand.id
        brand.name = row["brand"]
        logger.info "#{brand.name}"
        brand.save
      end

      model = find_by_name(row["model"]) || new

      unless model.id
        model.name = row["model"]
        logger.info "new model #{model.name} for #{brand.name}"
        brand.models << model        
      end
    end
  end
end
  