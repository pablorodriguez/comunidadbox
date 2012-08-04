require 'rubygems'
require 'rufus/scheduler'
require 'resque'
#require other classes which you want to use. Example any model or helper class which has implementation of required task
 
scheduler = Rufus::Scheduler.start_new
 
scheduler.every("1m") do
  #this will run in every 1 minutes.
  #Envia notificaciones de alarmas
  Resque.enqueue(AlarmJob)
end

scheduler.every("1d") do
  #this will run in every day.
  #Envias ofertas de servicios
  Resque.enqueue(ServiceOfferJob)
end
 
#You can schedule as many job as you want here