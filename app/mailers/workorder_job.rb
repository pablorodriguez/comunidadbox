class WorkorderJob
  @queue = :mails
  
  class << self
    def perform(work_order_id)
      logger.info "### entro al work order job"
      work_order = Workorder.find work_order_id
      message = WorkOrderJob.delay.notify(work_order)
      logger.info "############### work order enviada #{work_order.id} a #{work_order.car.user.email}"
    end
  end
end