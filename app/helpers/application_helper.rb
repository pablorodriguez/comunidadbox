# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def sortable(column,title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "sortable current #{sort_direction}" : "sortable"
    direction = column == sort_column && sort_direction == "asc" ? "desc":"asc"
    link_to_function title,"submitForm('#{column}' ,'#{direction}')",{:class => css_class}
  end
  
  def vineta
     image_tag("/images/vineta_4.png", :size => "39x21", :alt => "",:class=>:ordencontentimg)
  end
  
  def show_status status
    image_tag('ok.png') if status == "Terminado"
  end
  
  def link_to_pdf work_order
    if (work_order.company == current_user.company ||
      work_order.car.user == current_user)
      link_to image_tag('pdf.png'),workorder_path(work_order,:format =>'pdf'),:target => "_blank"
    end
  end
  
  def link_to_back(url=nil)    
    unless url
      return link_to_function "","javascript:history.back(-1)",:class =>"btn_back" unless url  
    else
      return link_to "",url,:class =>"btn_back" if url
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
    return image_tag("ok.png") if entity.active
    return link_to(image_tag("delete.png"),url,{:title => "Activar"}) unless entity.active
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
    company_id= current_user.company.id
    service_type_id = service_type.id
    st = ServiceType.all(:include=>:companies, :conditions => ["parent_id= ? and companies.id = ?",service_type_id,company_id])
    return st
  end
  
  def is_assigned service_type
    s = CompanyService.all(:conditions => ["service_type_id = ?",service_type])
     (s==nil or s.size==0) ? false:true 
  end
  
  def link_to_remove_fields(f,association)
    f.hidden_field(:_destroy) + link_to_function(image_tag('delete.png'),"remove_fields(this,\'#{association}\')")
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

end
