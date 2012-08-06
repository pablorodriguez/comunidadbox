#!/bin/sh
cd /home/deployer/apps/comunidadbox/current
kill -9 %(cat /home/deployer/apps/comunidadbox/current/tmp/pids/resque_worker_QUEUE.pid)
rm -f /home/deployer/apps/comunidadbox/current/tmp/pids/resque_worker_QUEUE.pid
