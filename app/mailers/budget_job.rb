class BudgetJob
  @queue = :mails
  
  def self.perform(budget_id)
      budget = Budget.find(budget_id)
      BudgetMailer.email(budget).deliver if budget
  end
end