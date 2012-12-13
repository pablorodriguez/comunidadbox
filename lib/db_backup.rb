#!/usr/bin/env ruby
databases = {
	:comunidad_box_dev => {
	:database => 'comunidadbox_prd',
	:username => 'combox',
	:password => 'combox'
	}
}

db_backups = ARGV.shift 
day_sec = (60 * 60 * 24)

backup_file =""

#create the db backup
databases.each do |name,config|

	backup_file = config[:database] + '_' + Time.now.strftime('%Y%m%d%H%M%S')

	mysqldump = "mysqldump -u#{config[:username]} -p#{config[:password]} " + "#{config[:database]}"	

	`#{mysqldump} > #{backup_file}.sql`
	`gzip #{backup_file}.sql`	
	`mv #{backup_file}.sql.gz #{db_backups}`

end

#delete backups old more than 2 days

files = Dir.glob("#{db_backups}*.gz")
files.sort.reverse[10..files.size].each {|f| `rm #{f}` } if files.size > 10

