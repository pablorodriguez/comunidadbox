class ExportJob
  @queue = :exports
  
  class << self
    def perform(id)      
      export = Export.find id    
      export.run_export 
    end
  end
end