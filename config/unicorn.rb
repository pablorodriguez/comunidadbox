root = "/home/deployer/apps/comunidadbox/current"
working_directory root
pid "#{root}/tmp/pids/unicorn_combox.pid"
stderr_path "#{root}/log/unicorn_combox.log"
stdout_path "#{root}/log/unicorn_combox.log"

listen "/tmp/unicorn.comunidadbox.sock"
worker_processes 2
timeout 30