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
  APPROVED = 12
  
  WO_STATUS = {
    OPEN=>'Abierto',IN_PROCESS=>'En Proceso',FINISHED=>'Terminado'
    }

  SR_STATUS = {
    OPEN=>'Abierto',CONFIRMED=>'Confirmado'
    }

  MR_STATUS = {
    OPEN =>'Abierto',APPROVED => 'Aprobado',REJECTED =>'Rechazado'
  }

  SO_STATUS = {    
      OPEN => 'Abierto',
      CONFIRMED => 'Confirmado',
      CANCELLED => 'Cancelado'
  }

  

  STATUS_IDS ={
    finished: FINISHED,in_progress: IN_PROCESS, open: OPEN, approved: APPROVED, rejected: REJECTED,sent: SENT
  }
  
  STATUS = {
    OPEN=>'Abierto',IN_PROCESS=>'En Proceso',CANCELLED=>'Cancelado',
    FINISHED=>'Terminado',COMPLETED=>'Completado',ACTIVE =>'Activo',
    CONFIRMED =>'Confirmado',PERFORMED =>'Realizado',SENT =>"Enviado",PENDING=>'Pendiente',
    REJECTED =>'Rechazado',APPROVED =>"Aprobado"
    }
  
  ALARMS_STATUS ={
    'Activo' =>ACTIVE,'Cancelado' =>CANCELLED
  }

  NOTES_STATUS = {"SOON"=>""}
    
  def self.status st
    STATUS[st]
  end
  
  
end