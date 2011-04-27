module WorkOrderHelper
  
  def show_rank(work_order,rank=:company)
    html=""
    title ="Calificacion de Empresa: "
    if (rank == :company)
      cssLink = current_user.company ? "link":""
    else  
      cssLink = current_user.company.nil? ? "link":""
    end
    
    
    cssStarSelect = "star_select #{cssLink}"
    cssStar = "star #{cssLink}"
    
    if rank == :company
      css ="comp_rank_stars"
      cal = work_order.company_rank ? work_order.company_rank.cal : 0
    else
      css ="usr_rank_stars"  
      cal = work_order.user_rank ? work_order.user_rank.cal : 0
      title ="Calificacion de Usuario: "
    end
    
    
    if cal > 0
      html = content_tag(:div,"",:class =>cssStarSelect,:id =>1,:title =>title + Rank::VALUES[1])
      (cal-1).times do |n|
        html << content_tag(:div,"",:class =>cssStarSelect,:id =>n+2,:title =>title + Rank::VALUES[n+2])
      end
      (5-cal).times do |n|
        html << content_tag(:div,"",:class =>cssStar,:id =>n+cal+1,:title =>title + Rank::VALUES[n+cal+1])
      end
    else
      html = content_tag(:div,"",:class =>cssStar,:id =>1,:title =>title + Rank::VALUES[1])
      4.times do |n|
        html << content_tag(:div,"",:class =>cssStar,:id =>n+2,:title =>title + Rank::VALUES[n+2])
      end
    end
    
    return content_tag(:div, html,:class =>css)
  end
  
  def get_company_rank(current_user,work_order)
    if work_order.finish?
      if(work_order.company_rank_id)
        rank = Rank.find work_order.company_rank_id
        return link_to("Calif: "<< rank.cal.to_s ,:controller => "ranks" , :action=>"show", :id=>rank.id , :cat=>"company")
      else
        if work_order.company.id != Company::DEFAULT_COMPANY_ID
          if (current_user.current_company && 
              work_order.company == current_user.current_company)
            return link_to('Calificar...', :controller => "ranks" ,:action => "new" , :wo_id => work_order.id , :cat => "company")
          else
            return ""
          end
        end
      end
    end
  end

  def get_user_rank(current_user,work_order)
    if work_order.user_rank_id
      rank = Rank.find work_order.user_rank_id
      return link_to("Calif: "<< rank.cal.to_s ,:controller => "ranks" , :action=>"show", :id=>rank.id , :cat=>"usr")
    else
      if work_order.company.id != Company::DEFAULT_COMPANY_ID
        if !current_user.current_company || work_order.belong_to_user(current_user)
          return link_to('Calificar...', :controller => "ranks" ,:action => "new" , :wo_id => work_order.id , :cat => "usr")
        else
          return ""
        end
      end
    end
  end
  

  def get_my_rank(current_user,work_order)
    if current_user.current_company
      if work_order.company_rank_id
        rank = Rank.find work_order.company_rank_id
        return link_to("Calif: "<< rank.cal.to_s ,:controller => "ranks" , :action=>"show", :id=>rank.id , :cat=>"company")
      else
        return link_to('Calificar...', :controller => "ranks" ,:action => "new" , :wo_id => work_order.id , :cat => "company")
      end
    else
      if work_order.user_rank_id
        rank = Rank.find work_order.user_rank_id
        return link_to("Calif: "<< rank.cal.to_s ,:controller => "ranks" , :action=>"show", :id=>rank.id , :cat=>"usr")
      else
        return link_to( 'Calificar...', :controller => "ranks" ,:action => "new" , :wo_id => work_order.id , :cat => "usr")
      end
    end
  end
  
  def get_other_rank(current_user,work_order)
    if current_user.company
      if work_order.user_rank_id
        rank = Rank.find work_order.user_rank_id
        return link_to("Calif: "<< rank.cal.to_s ,:controller => "ranks" , :action=>"show", :id=>rank.id , :cat=>"company")
      else
        return ""
      end
    else
      if work_order.company_rank_id
        rank = Rank.find work_order.company_rank_id
        return link_to("Calif: "<< rank.cal.to_s ,:controller => "ranks" , :action=>"show", :id=>rank.id , :cat=>"usr")
      else
        return ""
      end
    end
  end
  
  def can_edit? work_order
    @work_order.open? && @work_order.company.id == current_user.company_id
  end
  
end
