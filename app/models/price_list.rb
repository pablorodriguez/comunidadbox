  require 'csv'

class PriceList < ActiveRecord::Base
  has_many :price_list_items
  belongs_to :company
  
  alias :prices :price_list_items
  
  @@code_nro=0
  
  def price(material_code,service_type_id)
    m = Material.find_by_code(material_code)
    mst = MaterialServiceType.find_by_material_id_and_service_type_id(m.id,service_type_id)
    PriceListItem.find_by_price_list_id_and_material_service_type_id(self.id,mst.id)
  end
  
  def self.copy pl_id
    priceList = PriceList.find pl_id
    self.copy_price_list priceList
  end
  
  def self.copy_default company_id
    defaultPL = PriceList.find_by_id 1
    if defaultPL
       defaultPL.company_id = company_id
       self.copy_price_list defaultPL
    end
   
  end
  
  def self.copy_price_list pl
    newPL = PriceList.new
    newPL.company_id = pl.company_id
    #newPL.active = true
    newPL.name= "Copy - #{pl.name}"
    newPL.save
    ActiveRecord::Base.connection.execute("insert into price_list_items (price_list_id,material_service_type_id,price,created_at,updated_at) select #{newPL.id},material_service_type_id,price,now(),now() from price_list_items where price_list_id=#{pl.id}")  
    newPL    
  end
  
  def materials
    
  end
  
  def self.get_first_code_nro
    m = Material.first(:order => "id desc")
    id =0
    unless m == nil
      id= m.code.gsub(/\D/,'').to_i  
      @@code_nro = id +1
    else
      @@code_nro = 0
    end
  end
  
  def self.generate_code service_type_id
    code_type = set_code_type service_type_id
    code_nro+=1
    "#{code_type}#{format("%05d",@@code_nro)}"
  end
  
  def self.set_code_type service_type_id
    code_type = case service_type_id.to_i
      when 1
        "CA"
      when 2
        "CN"
      when 3
        "AB"
      when 4
        "MG"
      when 5
        "TR"
      when 7
        "SU"
      when 8
        "FE"
      when 9
        "AM"
    end
  end

  def self.import_price_from_file pl_id,file_name
    fileName = "#{RAILS_ROOT}/public/price_files/input/#{file_name}"
    file = File.open(fileName)
    logger.debug "Importing price from #{fileName}"
    import_item_price_file(pl_id,file,file_name)
  end

  def self.import_item_price_file(pl_id,file,file_name)
    pl = PriceList.find pl_id
    code = Material.where("code like 'CN%'").order("id DESC").first.code.scan(/\d+/).first.to_i + 1
    found = 0
    not_found = 0
    new_materials = []
    record = 0

    file.each do |r|
      record +=1
      logger.debug "#{record} #### #{r}"
      begin
        cell= r.split("\t")
        prov_code = cell[0].strip
        provider = cell[1].strip
        name = cell[2].strip
        price = cell[3].strip.to_f

        # busco el material a ver si existe
        m = Material.find_by_prov_code(prov_code)

        if m        
          # busco en la lista de precio si existe el material
          m.provider = provider
          m.name = name
          m.save

          item = PriceListItem.includes(:price_list,:material_service_type => [:material]).where("materials.prov_code = ? and price_lists.id = ?",
            prov_code,pl_id).first

          if item
            item.price = price
            item.save
          else
            # creo un item de prcio de lista 
            #pl.price_list_items.create(:material_service_type_id => 2,:price => price)
          end
          found += 1
        else  
          row =  Array[prov_code,brand,name,price]
          new_materials << row
          #creo el nuevo material
          #m = Material.create(:prov_code => prov_code,:code =>"CN#{code}",:name => name,:brand =>brand,:provider => provider)

          # creo un un material service type tipo 2 , Cambio de Neumatico
          #mst = MaterialServiceType.create(:material_id => m.id,:service_type_id => 2)

          # creo un item de prcio de lista 
          #pl.price_list_items.create(:material_service_type_id => mst.id,:price => price)

          #code += 1
          not_found += 1
          #puts "\t #{m.id} #{m.code} #{m.name} #{prov_code} ### #{m.id}"
        end
      rescue Exception
        logger.error "#### Error reading record #{record} #{r}"
      end
    end   
    file.close
    result = {}
    result[:not_found] = not_found
    result[:found] = found
    #result[:rows] = new_materials
    result[:not_found_material] = "not_found_" + file_name
    save_material_not_found(file_name,new_materials)
    result
  end

  def self.save_material_not_found(file_name,materials)    
    logger.debug "Saving file materila not found #{file_name} : materiales : #{materials.size}"
    File.open("#{RAILS_ROOT}/public/price_files/output/not_found_" + file_name, 'w') do|f|
      materials.each do |m| 
        str = m.join("\t") + "\n"
        str = str.force_encoding('UTF-8')
        logger.debug "### #{m} #{str}"
        f.write(str)
      end
    end 
  end
  

  def self.import_item_price(pl_id,file_name)
    puts File.file? file_name
    file = File.open(file_name)
    import_item_price_file(pl_id,file,"Bridgestone")
  end

  
  
  def self.import_price(name)
    get_first_code_nro
    messageFiles = "D:\\Users\\pablo\\Documents\\My Empresa\\ComunidadBox\\database\\#{name}.txt"
    r=0
    errors = Array.new
    pl = PriceList.find 1
    
    File.open(messageFiles).each do |record|
        r+=1
        cell = record.split("\t")
        code = cell[0]
        name =cell[1]
        price = cell[2]
        st_id = cell[4]
        m = Material.new
        begin
          Material.transaction do
            m.prov_code = code
            m.code = generate_code st_id
            m.name = name
            if m.save
              mst = MaterialServiceType.new
              mst.material = m
              mst.service_type_id = st_id
              mst.save
              
              pli = PriceListItem.new
              pli.price_list = pl
              pli.material_service_type = mst
              pli.price = price
              pli.save
              
              pl.price_list_items << pli
              pl.save
            else
              puts "Error ############## #{code}"              
              errors << m
            end
          end
        rescue
          errors << m
        end
        puts "#{code}  #{name} Price #{price} #{st_id}"
    end
    puts "Total de registros #{r}"
    puts "Total grabados #{r - errors.length}"
    puts "Total de Errores #{errors.length}"
    errors.each do |e|
      puts "#{e.code}  #{e.name}"
      e.errors.each_full { |msg| puts msg }
    end
  end
  

  def update_price_list

  end
  
  
end
