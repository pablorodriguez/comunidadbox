# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  #devuleve un Array del company id del Cookies o si ID de todas las compañias del Usuario registrado si en la cookie hay -1
  def company_id
    id = cookies[:company_id]
    if id == "-1"
      return current_user.companies.map(&:id)
    elsif id
      return id.split(",")
    else
      nil
    end
  end

  def all_company?
    cookies[:company_id] == "-1"
  end

  def multiple_company?
    return (all_company? || (cookies[:company_id].split(",").size > 1) )
  end

  def set_company_in_cookie(company_id)
    cookies.permanent[:company_id]= company_id.join(",")
  end

  def get_company params=nil    
    if (company_id == nil) 
      return Company.find(params[:company_id])
    elsif all_company?
      return current_user.company
    else
      return Company.find(company_id.first)
    end
    #company_id.empty? ? Company.find(params[:company_id]) : Company.where("id IN (?)",company_id).first
  end
    
  def get_companies params=nil    
    company_id.empty? ? Array(Company.find(params[:company_id])) : Company.where("id IN (?)",company_id)
  end
  
  def get_company_id params=nil    
    get_company(params).id
  end

  def get_service_types
    company_id ? CompanyService.companies(company_id) : current_user.service_types
  end

  def is_client client
    current_user.is_client? client
  end

  def sortable(column,title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "sortable current #{sort_direction}" : "sortable"
    direction = column == sort_column && sort_direction == "asc" ? "desc":"asc"
    link_to_function title,"submitForm('#{column}' ,'#{direction}')",{:class => css_class}
  end
  
  def icon_status(status)
    return image_tag("icon_unlock.png",:class =>"status",:title =>Status.status(status)) if [Status::OPEN,Status::IN_PROCESS].include?(status)  
    return image_tag("icon_lock.png",:class =>"status",:title =>Status.status(status)) if status == Status::FINISHED
    return image_tag("confirmed.png",:class =>"status",:title =>Status.status(status)) if status == Status::CONFIRMED
    return image_tag("sent.png",:class =>"status",:title =>Status.status(status)) if status == Status::SENT
    return image_tag("cancelled.png",:class =>"status",:title =>Status.status(status)) if status == Status::CANCELLED
    return image_tag("performed.png",:class =>"status",:title =>Status.status(status)) if status == Status::PERFORMED
    return image_tag("active.png",:class =>"status",:title =>Status.status(status)) if status == Status::ACTIVE
  end
  
  def event_class event
    css = "verde" if event.is_green
    css = "rojo" if event.is_red
    css ="amarillo" if event.is_yellow
    return css
  end
  
  def big_event_class event
    if event.service.workorder.company.id == company_id
      return "my_big_event"  
    else
      return "big_event"  
    end
  end
  
  def my_event_class event
    css = event_class event
    css = "mi_" + css if event.service.workorder.company.id == company_id
    return css
  end
  
  def brand_logo brand_name,thumb=false
    return image_tag("/images/brands/#{brand_name}.png",:size =>"50x50",:atl=>brand_name,:title =>brand_name) if thumb
    return image_tag("/images/brands/#{brand_name}.png",:size =>"50x50",:atl=>brand_name,:title =>brand_name)
    
  end
  def current_col_css(column)
    column == sort_column ? "current_col" : ""
  end
  
  def vineta
     image_tag("/images/vineta_4.png", :size => "39x21", :alt => "",:class=>:ordencontentimg)
  end
  
  def show_status status
    image_tag('ok.png',{:title => Status.status(status)}) if status == Status::FINISHED
  end
  
  def link_to_pdf work_order
    link_to "",workorder_path(work_order,:format =>'pdf'),:target => "_blank",:title =>"Imprimir",:class =>:pdf
  end
  
  def print_to_pdf work_order
    link_to "",print_workorder_path(work_order,:format =>'pdf'),:target => "_blank",:title =>"Imprimir Formulario",:class =>:pdf 
  end
  
  def link_to_back(url=nil)    
    unless url
      return link_to_function "<","javascript:history.back(-1)",:class =>"button" unless url  
    else
      return link_to "<",url,:class =>"button" if url
    end
    
  end
 
  def title(title)
    content_for(:title){title}
  end
  
  def javascript(*files)
    content_for(:head){javascript_include_tag(*files)}
  end
  
  def user_css
    css="/user.css"
    if current_user && !current_user.companies.nil?
      css="/company.css"
    else 
      if current_user && current_user.is_super_admin
        css="/admin.css"
      end
    end
    css="/user.css"
    content_for(:head){stylesheet_link_tag(css)}
  end
  
  def activate(company)
    if company.active
      return image_tag('active.png')
    else
      return link_to(image_tag("disable.png"),activate_company_path(company),{:title => "Activar"})
    end
  end
  
  def is_active(entity,url=root_path)
    return image_tag("cruz_verde.png") if entity.active
    return link_to(image_tag("confirmed.png"),url,{:title => "Activar"}) unless entity.active
  end
  
  def stylesheets(*files)
    content_for(:head){stylesheet_link_tag(*files)}
  end
  
  def hasCompany(user)
    value = false
    value = true if (@user.company.name != nil)
    value
  end
  
  def v(value)
    return value.id.nil? ? "": value.id
  end
  
  def tree_select(categories, model, name, selected=0, level=0, init=true)
    html = ""
    # The "Root" option is added
    # so the user can choose a parent_id of 0
    if init
      # Add "Root" to the options
      html << "<select name=\"#{model}[#{name}]\" id=\"#{model}_#{name}\">\n"
      html << "\t<option value=\"\""
      html << "></option>\n"
    end
    
    if categories.length > 0
      level += 1 # keep position
      categories.collect do |cat|
        html << "\t<option value=\"#{cat.id}\" style=\"padding-left:#{level * 10}px\""
        html << ">#{cat.name}</option>\n"
        html << tree_select(cat.children, model, name, selected, level, false)
      end
    end
    html << "</select>\n" if init
    return html
  end
  
  def search_children_service_type service_type
    st = ServiceType.all(:conditions => ["parent_id= ?",service_type.id])
    return st
  end
  
  def search_children_company_service_type service_type
    company_id= company_id
    service_type_id = service_type.id
    st = ServiceType.all(:include=>:companies, :conditions => ["parent_id= ? and companies.id = ?",service_type_id,company_id])
    return st
  end
  
  def is_assigned service_type
    s = CompanyService.all(:conditions => ["service_type_id = ?",service_type])
     (s==nil or s.size==0) ? false:true 
  end
  
  def link_to_remove_fields(f,association,title = "")
    f.hidden_field(:_destroy) + link_to_function("","remove_fields(this,\'#{association}\')",:title=>title,:class=>"delete right")
  end
  
  
  def link_to_add_fields(name, f, association)  
    new_object = f.object.class.reflect_on_association(association).klass.new  
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|  
      render(association.to_s.singularize + "_fields", :f => builder)  
    end  
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")",:id=>:new_car_link)  
  end
  
  def link_to_add_fields(name, f, association)  
    new_object = f.object.class.reflect_on_association(association).klass.new  
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|  
      render(association.to_s.singularize + "_fields", :f => builder)  
    end  
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")",:id=>"#{association}_link")  
  end 
  
  def button_to_add_fields(name, f, association)  
    new_object = f.object.class.reflect_on_association(association).klass.new  
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|  
      render(association.to_s.singularize + "_fields", :f => builder)  
    end  
    button_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")",:id=>"#{association}_link")  
  end 
  
  def button_to_address_add_fields(name, f, association)  
    new_object = f.object.class.reflect_on_association(association).klass.new  
    new_object.address = Address.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|  
      render(association.to_s.singularize + "_fields", :f => builder)  
    end  
    button_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")",:id=>"#{association}_link")  
  end 
  
  def find_models car
    model = Model.find_all_by_brand_id(car.brand_id,:order=>:name)
    model
  end

  def create_service_type_tool_tip oe    
    st=""
    if (oe && oe.respond_to?(:length))
      st = ServiceType.find(oe).map(&:name).join(",")
    elsif oe      
      st = ServiceType.find(oe).name
    end
    logger.debug "### search id #{oe} #{st}"
    return st
  end
   

end
