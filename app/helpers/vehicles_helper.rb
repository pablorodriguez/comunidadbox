# encoding: utf-8
module VehiclesHelper
  def sti_vehicle_path(type = 'vehicle', vehicle = nil, action = nil)
    send "#{format_sti(action, type, vehicle)}_path", vehicle
  end

  def format_sti(action, type, vehicle)
    action || vehicle ? "#{format_action(action)}#{type.underscore}" : "#{type.underscore.pluralize}"
  end

  def format_action(action)
    action ? "#{action}_" : ""
  end

end
