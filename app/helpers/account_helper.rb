module AccountHelper
  
  def search_country_name state_id
    if state_id
      return State.find(state_id).country().name 
    end
    
  end
end