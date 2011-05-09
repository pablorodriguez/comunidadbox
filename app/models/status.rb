class Status
  
  OPEN=1
  IN_PROCESS=2
  CANCELLED=3
  FINISHED=4
  COMPLETED=5
  ACTIVE =6
  
  WO_STATUS = {OPEN=>'Abierto',IN_PROCESS=>'En Proceso',CANCELLED=>'Cancelado',FINISHED=>'Terminado'}
    
  def self.status st
    WO_STATUS[st]
  end
  
  def self.open
    status OPEN
  end
  
  def self.finish
    status FINISHED
  end
    
  def self.cancel
    status CANCELLED
  end
  
  def self.in_process
    status IN_PROCESS
  end
end