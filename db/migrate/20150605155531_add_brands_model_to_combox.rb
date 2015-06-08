class AddBrandsModelToCombox < ActiveRecord::Migration
  def change
    Brand.where("company_id = 12").each do |b|
      nb = Brand.new
      nb.name = b.name
      nb.company_id = 1
      nb.of_cars=b.of_cars
      nb.of_motorcycles = b.of_motorcycles
      nb.save
      b.models.each do |m|
        nm = Model.new
        nm.brand_id = nb.id
        nm.name = m.name

        nm.save
      end
    end
  end
end
