class Status
  
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
  
  WO_STATUS = {
    OPEN=>'Abierto',IN_PROCESS=>'En Proceso',FINISHED=>'Terminado'
    }

  WO_STATUS_IDS ={
    finished: FINISHED,in_progress: IN_PROCESS, open: OPEN
  }
  
  STATUS = {
    OPEN=>'Abierto',IN_PROCESS=>'En Proceso',CANCELLED=>'Cancelado',
    FINISHED=>'Terminado',COMPLETED=>'Completado',ACTIVE =>'Activo',
    CONFIRMED =>'Confirmado',PERFORMED =>'Realizado',SENT =>"Enviado",PENDING=>'Pendiente',
    REJECTED =>'Rechazado'
    }
  
  ALARMS_STATUS ={
    'Activo' =>ACTIVE,'Cancelado' =>CANCELLED
  }

  NOTES_STATUS = {"SOON"=>""}
    
  def self.status st
    STATUS[st]
  end
  
  
end