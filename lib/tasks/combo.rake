task "reset_db" => :environment do
  
  Rake::Task["db:drop"].invoke
  puts "Drop database"
  
  Rake::Task["db:create"].invoke
  puts "Create database"
  
  `mysql -ucombox -pcombox comunidadbox_payment < ~/Downloads/combox_prd_20150126180001.sql`
  puts "Restore done"
  
end