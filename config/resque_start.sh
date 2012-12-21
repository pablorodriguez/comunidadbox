#/bin/sh
cd /home/deployer/apps/comunidadbox/current
nohup bundle exec rake resque:work RAILS_ENV=production QUEUE=* VERBOSE=1 PIDFILE=/home/deployer/apps/comunidadbox/current/tmp/pids/resque_worker_QUEUE.pid & >> /home/deployer/apps/comunidadbox/current/log/resque_worker_QUEUE.log 2> /home/deployer/apps/comunidadbox/current/log/resque_worker.log
