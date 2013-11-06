json.(@service_request,:id)
json.car(@service_request.car,:id,:domain)
json.item_service_requests @service_request.item_service_requests do |isr|           
  json.id isr.id
  json.service_type do
    json.id isr.service_type.id
    json.description isr.description
    json.name isr.service_type.name
  end  
end
