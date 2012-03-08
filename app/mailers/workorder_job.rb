class WorkorderJob
  @queue = :mails
  
  class << self
    def perform(work_order_id)
      work_order = Workorder.find work_order_id
      if work_order.car.domain == "HRJ549"
        WorkOrderNotifier.notify(work_order).deliver  
      end      
    end
  end
end