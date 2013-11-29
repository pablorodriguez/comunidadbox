class UpdateMaterialsBrand < ActiveRecord::Migration
  def up
    execute "update materials set brand=provider where provider in ('MICHELIN','FIRESTONE','FATE','PIRELLI','BRIDGESTONE','GOODYEAR')"

    execute "update materials set provider=NULL where provider in ('MICHELIN','FIRESTONE','FATE','PIRELLI','BRIDGESTONE','GOODYEAR')"

    execute "update materials set provider=NULL where provider in ('')"

    execute "update materials set brand=NULL where brand in ('')"
  end

  def down
  end
end
