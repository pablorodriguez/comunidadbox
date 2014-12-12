# encoding: utf-8
class Model < ActiveRecord::Base
  attr_accessible :brand_id, :name

  scope :all_sorted, includes("brand").order('brands.name,models.name')

  has_many :vehicles
  belongs_to :brand
  validates_presence_of :brand

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


  def self.import(file)
    CSV.foreach(file.path,{:headers =>  true, :col_sep =>"\t"}) do |row|
      brand = Brand.find_by_name(row["brand"]) || new
      unless brand.id
        brand.name = row["brand"]
        brand.save
      end

      model = find_by_name(row["model"]) || new

      unless model.id
        model.name = row["model"]
        brand.models << model
      else
        model.name = model.name.de
      end
    end
  end


end
