task "reset_db" => :environment do
  
  Rake::Task["db:drop"].invoke
  puts "Drop database"
  
  Rake::Task["db:create"].invoke
  puts "Create database"
  
  `mysql -ucombox -pcombox combox_vehicle < ~/Dropbox/MiEmpresa/ComunidadBox/database/prd_backup/combox_prd.sql`
  puts "Restore done"
  
end