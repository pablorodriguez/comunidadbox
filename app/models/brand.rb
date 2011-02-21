class Brand < ActiveRecord::Base
  has_many :cars
  has_many :models
  
  def self.import
    messageFiles = "D:\\Users\\pablo\\Documents\\My Empresa\\ComunidadBox\\database\\auto-brand-model-fram.txt"
    last_brand =''
    brand = Brand.new
    parecidos = 0
    nuevos = 0
    File.open(messageFiles).each do |record|
        cell = record.split("\t")
        brand_name = cell[0]
        model_name =cell[1]
        #puts "#{brand_name} : #{model_name}"
        if last_brand != brand_name
          last_brand = brand_name
          brand = Brand.where("upper(name) = ?",brand_name)
          if brand.size > 0
            brand = brand[0]
          else
            brand = Brand.create([:name => brand_name])[0]
            puts " Nueva marca ### #{brand_name}"
          end
          
        end
        models = brand.models.where("name like ?","#{model_name}")
        if models.size > 0
          parecidos += 1
          puts "modelo parecido #{model_name} para #{brand_name} "
          models.each do |m|
            puts " #{m.name}"
          end
        else
          brand.models.create(:name =>model_name)
          puts "modelo creado #{brand_name} : #{model_name}"
          nuevos +=1
        end
    end
    puts "Modelos parecidos: #{parecidos}, Modelos nuevos :#{nuevos}"
  end
  
  def self.remove_duplicate
    brands = Brand.all
    brands.each do |b|
      m= b.models
      m.each do |m1|
        mm = b.models.where("name like ?", "%#{m1.name}")
        if mm.size > 2
          puts "#{mm[0].name} count: #{mm.size}"
        end
      end
      
    end
    puts brands.size
  end
  
end
