#!/usr/bin/env ruby
databases = {
	:comunidad_box_dev => {
	:database => 'comunidadbox_development',
	:username => 'combox',
	:password => 'combox'
	}
}

end_of_iter = ARGV.shift

databases.each do |name,config|

	if end_of_iter.nil?
		backup_file = config[:database] + '_' + Time.now.strftime('%Y%m%d')
	else
		backup_file = config[:database] + '_' + end_of_iter
	end

	mysqldump = "mysqldump -u#{config[:username]} -p#{config[:password]} " + "#{config[:database]}"	

	`#{mysqldump} > #{backup_file}.sql`
	`gzip #{backup_file}.sql`

end