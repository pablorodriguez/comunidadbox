class Status < ActiveRecord::Base
  attr_accessible :name

  belongs_to :company
  
  OPEN = 1
  IN_PROCESS = 2
  CANCELLED = 3
  FINISHED =4
  COMPLETED = 5
  ACTIVE = 6
  CONFIRMED = 7
  PERFORMED = 8
  SENT = 9
  PENDING = 10
  REJECTED = 11
  APPROVED = 12
  WAITING = 13
  RUNNING = 14
  DONE = 15
  OPEN_FOR_AUTOPART = 16

  WO_STATUS = {
    OPEN=> I18n.t("open"),IN_PROCESS=>I18n.t('in_process'),FINISHED=>I18n.t('finished')
    }
    #,OPEN_FOR_AUTOPART => 'Disponible para cotizar'

  SR_STATUS = {
    OPEN=>I18n.t("open"),CONFIRMED=>'Confirmado'
    }

  MR_STATUS = {
    OPEN =>I18n.t("open"),APPROVED => 'Aprobado',REJECTED =>'Rechazado'
  }

  SO_STATUS = {    
      OPEN => I18n.t("open"),
      CONFIRMED => 'Confirmado',
      CANCELLED => 'Cancelado'
  }

  EX_STATUS = {
    WAITING =>"En espera",RUNNING=>'Generando los archivos..',DONE=>'Terminado'
  }
  

  STATUS_IDS ={
    finished: FINISHED,in_progress: IN_PROCESS, open: OPEN, approved: APPROVED, rejected: REJECTED,sent: SENT, open_for_autopart: OPEN_FOR_AUTOPART
  }
  
  STATUS = {
    OPEN=>I18n.t("open"),IN_PROCESS=>'En Proceso',CANCELLED=>'Cancelado',
    FINISHED=>'Terminado',COMPLETED=>'Completado',ACTIVE =>'Activo',
    CONFIRMED =>'Confirmado',PERFORMED =>'Realizado',SENT =>I18n.t("sent"),PENDING=>'Pendiente',
    REJECTED =>'Rechazado',APPROVED =>"Aprobado"
    }
  
  ALARMS_STATUS ={
    I18n.t("active") => 'Active',I18n.t("canceled") =>'Cancelado'
  }

  NOTES_STATUS = {"SOON"=>""}
    
  def self.status st
    STATUS[st]
  end
  
  
end