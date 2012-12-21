#!/bin/sh
cd /home/deployer/apps/comunidadbox/current
kill -QUIT $(cat /home/deployer/apps/comunidadbox/current/tmp/pids/resque_worker_QUEUE.pid)
rm -f /home/deployer/apps/comunidadbox/current/tmp/pids/resque_worker_QUEUE.pid
