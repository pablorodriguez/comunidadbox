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
    newPL.active = true
    newPL.name= pl.name
    newPL.save
    ActiveRecord::Base.connection.execute("insert into price_list_items (price_list_id,material_service_type_id,price,created_at,updated_at) select #{newPL.id},material_service_type_id,price,now(),now() from price_list_items where price_list_id=#{pl.id}")  
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
    set_code_type service_type_id
    @@code_nro+=1
    "#{@@code_type}#{format("%05d",@@code_nro)}"
  end
  
  def self.set_code_type service_type_id
    @@code_type = case service_type_id.to_i
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
  
  
  
end
