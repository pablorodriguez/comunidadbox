class PriceList < ActiveRecord::Base
  attr_accessible :name,:active
  
  has_many :price_list_items
  belongs_to :company
  
  alias :prices :price_list_items
  
  @@code_nro=0

  def can_edit?(user)
    user.own(self.company)
  end

  def can_delete?(user)
    return false if (self.company.headquarter and self.active)
    return user.own(self.company)
  end
  
  def price(material_code,service_type_id)
    m = Material.find_by_code(material_code)
    mst = MaterialServiceType.find_by_material_id_and_service_type_id(m.id,service_type_id)
    PriceListItem.find_by_price_list_id_and_material_service_type_id(self.id,mst.id)
  end

  def activate    
    PriceList.transaction do
      PriceList.where("company_id = ?",self.company_id).update_all(:active => false)
      self.update_attributes :active => (self.active ? false : true)      
    end    
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
  
  
  # usar este metodo para importar lista de precios
  def self.import_price_from_file pl_id,file_name
    fileName = "#{RAILS_ROOT}/public/price_files/input/#{file_name}"
    #fileName = "/home/pablo/price_files/input/#{file_name}"
    file = File.open(fileName)
    logger.info "Importing price from #{fileName}"
    import_item_price_file(pl_id,file,file_name)
  end

  def self.import_item_price_file(pl_id,file,file_name)
    start=  Time.zone.now

    pl = PriceList.find pl_id    
    found = 0
    not_found = 0
    errors = []
    record = 0
    new_materials = []    
    no_price_item = []
    new_material_service_type = []

    file.each do |row|
      record +=1 
      puts record
      r = row.clone.force_encoding('ASCII-8BIT')     
      begin
        cell= r.split("\t")        
        prov_code = cell[0].strip
        provider = cell[1].strip
        name = cell[2].force_encoding('ASCII-8BIT').strip
        price = cell[3].strip.to_f

        # busco el material a ver si existe
        m = Material.find_by_prov_code(prov_code)        
        unless m
          not_found += 1
          row =  Array[prov_code,provider,name,price]
          new_materials << row
          if cell[4]
            service_type_id = cell[4].strip.to_i
            st = ServiceType.find(service_type_id)
            new_code = Material.where("code like '#{st.code}%'").order("code DESC").first.code.scan(/\d+/).first.to_i + 1

            #creo el nuevo material
            m = Material.new(:prov_code => prov_code,:code =>"#{st.code}#{format('%05d',new_code)}",:name => name,:provider => provider)            
            m.save
            # creo un un material service type 
            mst = MaterialServiceType.create(:material_id => m.id,:service_type_id => st.id)            
          end          
        end

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
            no_price_item << r 
            # creo un item de prcio de lista 
            m_s_t = MaterialServiceType.where("material_id = ? ",m.id)
            m_s_t.each do |mst|
              pl.price_list_items.create(:material_service_type_id => mst.id,:price => price)
              new_material_service_type << "#{mst.id} #{mst.material.prov_code} #{mst.material.name} #{price}"
            end
            
          end
          found += 1        
        end
      rescue Exception        
        puts "#### Error reading record #{record} #{r}"
        puts "#{$!}"
        errors << "#{record} #{r} #{$!}"
      end
    end   
    file.close
    result = {}
    result[:not_found] = not_found
    result[:errors] = errors.size
    result[:found] = found
    result[:item_not_found] = no_price_item.size
    result[:new_material_service_type] = new_material_service_type.size
    #result[:rows] = new_materials
    result[:not_found_material] = "not_found_" + file_name
    
    save_material_not_found(file_name,new_materials)
    save("item_not_found_" + file_name,no_price_item)
    save("new_material_service_type"+file_name,new_material_service_type)
    timeEnd = Time.zone.now

    puts "Start: #{start}  End: #{timeEnd}, total time: #{(timeEnd - start)}"
    errors.each do |e|
      puts e
    end

    result
  end

  def self.save file_name,items
    out_put_file = "/home/pablo/price_files/output/" + file_name
    File.open(out_put_file, 'w:ASCII-8BIT') do|f|
      items.each do |item|
        f.write(item)
      end
    end 
  end

  #grabo materiales no encontrados
  def self.save_material_not_found(file_name,materials)    
    logger.info "Saving file materila not found #{file_name} : materiales : #{materials.size}"
    #out_put_file = "#{RAILS_ROOT}/public/price_files/output/not_found_" + file_name
    out_put_file = "/home/pablo/price_files/output/not_found_" + file_name
    File.open(out_put_file, 'w') do|f|
      materials.each do |m| 
        str = m.join("\t") + "\n"
        str = str.force_encoding('UTF-8')
        logger.info "### #{m} #{str}"
        f.write(str)
      end
    end 
  end

  #chequea que los codigos de proveedor sean unicos
  def self.check_prov_code file_name
    prov_code = {}
    fileName = "/home/pablo/price_files/input/#{file_name}"
    
    err_file = File.new("/home/pablo/price_files/output/err_" + file_name,"w+")

    file = File.open(fileName)
    rs = 0
    er = 0
    puts "reading #{fileName}"
    str =""
    row =""
    file.each do |r|
        begin
          rs +=1  
          row = r.clone
          str = r.force_encoding('ASCII-8BIT')

          cell= str.split("\t")
          code = cell[0].strip

          provider = cell[1].strip
          name = cell[2].strip
          price = cell[3].strip.to_f

          if prov_code[code]
            prov_code[code] += 1
            puts row
          else
            prov_code[code] = 1
          end
        rescue Exception
          #logger.error "#### Error reading record #{r}"          
          puts "#{$!}"
          puts "#{row} #{rs}"
          #err_file.write $!
          err_file.write "#{row} #{rs} #{$!}"
          er +=1
        end
    end
    err_file.close

    puts "end reading"
    out_put_file = "/home/pablo/price_files/output/dup_" + file_name
    File.open(out_put_file, 'w') do|f|
      puts "writing in #{out_put_file}"
      prov_code.each do |k,v|
        if v > 1
          str = "#{k} \t #{v}\n"
          f.write(str)
        end
      end
    end
    puts "records #{rs} erros #{er}"
    return ""
  end
  
  def self.find_active_price_list(user)
    PriceList.where("company_id = ? && active = ?", user.company_active.id, 1).first
  end
end
