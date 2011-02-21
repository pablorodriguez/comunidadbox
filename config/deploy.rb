set :application, "comunidadbox"
set :repository,  "git@comunidadbox.com:myrepo.git "

set :scm, :git
set :scm_username, "git"  # The server's user for deploys
set :scm_password, "git5624"  # The deploy user's password

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "www.comunidadbox.com"                          # Your HTTP server, Apache/etc
role :app, "www.comunidadbox.com"                          # This may be the same as your `Web` server
role :db,  "www.comunidadbox.com", :primary => true # This is where Rails migrations will run
role :db,  "www.comunidadbox"



# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end