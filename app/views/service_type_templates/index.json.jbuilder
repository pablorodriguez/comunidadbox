json.array!(@templates) do |json, temp|
  json.(temp,:id,:service_type_id,:name)  
  json.materials temp.material_service_type_templates,:id,:amount,:material,:material_service_type_id,:price
end
