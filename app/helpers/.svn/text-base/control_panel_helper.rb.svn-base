module ControlPanelHelper

  def send_other_parameters_for_filtering(from)
    onchange = ''
    onchange += (params[:brand_id] && from != "brand_id") ? "&brand_id=#{params[:brand_id]}" : ""
    onchange += (params[:model_id] && from != "model_id") ? "&model_id=#{params[:model_id]}" : ""
    onchange += (params[:service_type_id] && from != "service_type_id") ? "&service_type_id=#{params[:service_type_id]}" : ""
    onchange += (params[:fuel_id] && from != "fuel_id") ? "&fuel_id=#{params[:fuel_id]}" : ""
    onchange += (params[:year] && from != "year") ? "&year=#{params[:year]}" : ""
    onchange += (params[:city] && from != "city") ? "&city=#{params[:city]}" : ""
    return onchange
  end

  def v value
    return value.nil? ? "": value.id
  end

end
