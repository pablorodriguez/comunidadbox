# encoding: utf-8
module WorkOrderHelper

  def show_company_info vehicle
    capture do
      concat content_tag(:label,"[#{vehicle.user.company_name}]",:title => I18n.translate("business_name")) if (vehicle.user.company_name && (not vehicle.user.company_name.empty?))
      concat " "
      concat content_tag(:label,"[#{vehicle.user.cuit}]",:title => I18n.translate("cuit")) if (vehicle.user.cuit && (not vehicle.user.cuit.empty?))
    end
  end

  def show_rank(cal,css="")
    html=""
    title =""

    cssStarSelect = "star_select #{css} cal"
    cssStar = "star #{css} cal"
    css ="rank_stars"

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
    if work_order.is_finished?
      if(work_order.company_rank_id)
        rank = Rank.find work_order.company_rank_id
        return link_to("Calif: "<< rank.cal.to_s ,:controller => "ranks" , :action=>"show", :id=>rank.id , :cat=>"company")
      else
        if work_order.company.id != Company::DEFAULT_COMPANY_ID
          if (company_id &&
              work_order.company.id == get_company.id)
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
        if !company_id || work_order.belong_to_user(current_user)
          return link_to('Calificar...', :controller => "ranks" ,:action => "new" , :wo_id => work_order.id , :cat => "usr")
        else
          return ""
        end
      end
    end
  end


  def get_my_rank(current_user,work_order)
    if company_id
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
    if company_id
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
    # si la orden esta abierta and la orden fue creada por el due??o del auto or la empresa de la orden es igual a la emprea del usuario loggeado
    work_order.is_open? && (work_order.user.id == work_order.vehicle.user.id) || (work_order.company.id == get_company.id)
  end

end
