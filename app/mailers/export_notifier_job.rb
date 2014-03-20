class ExportNotifierJob
  @queue = :mails
  
  class << self
    def perform(export_id)
      export = Export.find export_id      
      ExportNotifier.notify(export).deliver      
    end
  end
end