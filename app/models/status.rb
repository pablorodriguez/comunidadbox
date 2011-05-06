class Status
  ACTIVE =1
  OPEN=2
  IN_PROCESS=3
  CANCELED=4
  OVER=5
  COMPLETED=6
  
  WO_STATUS = {'Abierto'=>1,'En Proceso'=>2,'Cancelado'=>3,'Terminado'=>4}
    
  def self.status st
    WO_STATUS[st]
  end
  
  def self.open
    status "Abierto"
  end
  
  def self.finish
    status "Terminado"
  end
    
  def self.cancel
    status "Cancelado"
  end
  
  def self.in_progress
    status "En Proceso"
  end
end