# encoding: utf-8
class Model < ActiveRecord::Base
  attr_accessible :brand_id, :name

  scope :all_sorted, includes("brand").order('brands.name,models.name')

  has_many :vehicles
  belongs_to :brand
  has_and_belongs_to_many :companies

  validates_presence_of :brand
  #validate :brand_has_that_type_of_vehicle

  TYPES_OF_VEHICLES = { 1 => I18n.t("types_of_vehicles.car"), 2 => I18n.t("types_of_vehicles.motorcycle")}

  def self.to_csv(options={})
    CSV.generate(options) do |csv|
      csv << ["brand","model"]
      Model.all_sorted.each do |model|
        csv << [model.brand.name,model.name.delete('"').chomp(" ").chomp("\n")]
      end
    end
  end

  def self.to_xls()
    book = Spreadsheet::Workbook.new
    data = book.create_worksheet :name => name

    header_format = Spreadsheet::Format.new :color => :green, :weight => :bold
    data.row(0).default_format = header_format
    data.row(0).push "brand","model"

    Model.all_sorted.each_with_index do |model,index|
      data.row(index+1).push model.brand.name,model.name
    end

    blob = StringIO.new('')
    book.write(blob)
    blob
  end


  def self.import(file,company_id)
    CSV.foreach(file.path,{:headers =>  true}) do |row|
      brand = Brand.where("UPPER(name) = ?",row["brand"].upcase).first || Brand.new
      unless brand.id
        brand.name = row["brand"]
        brand.company_id = company_id
        brand.of_motorcycles = 1
        brand.save
      end

      model = Model.where("UPPER(name) = ?",row["model".upcase]).first || Model.new
      model.name = row["model"]
      model.brand_id = brand.id
      model.save

    end
  end

  def brand_has_that_type_of_vehicle
    brand_has_that_type = false
    case type_of_vehicle
      when 1
        brand_has_that_type = brand.of_cars
      when 2
        brand_has_that_type = brand.of_motorcycles
    end
    errors.add(:base, "La Marca seleccionada no posee el tipo de vehiculo indicado") if !brand_has_that_type
  end
end
