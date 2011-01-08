class Event < ActiveRecord::Base
  belongs_to :service_type
  belongs_to :car
  belongs_to :service

 
  named_scope :red, lambda {{:conditions => ["dueDate < ?", Time.now.months_since(1)]} }
  named_scope :yellow, lambda {{:conditions => ["dueDate > ? AND dueDate < ?",Time.now.months_since(1), Time.now.months_since(2)]} }
  named_scope :green, lambda {{:conditions => ["dueDate > ? ",Time.now.months_since(2)]} }

  named_scope :modeled, lambda { |model| { :joins => :car, :conditions =>  ["cars.model_id = ?", model] } }
  named_scope :branded, lambda { |brand| { :joins => :car, :conditions =>  ["cars.brand_id = ?", brand] } }
  named_scope :yeared, lambda { |year| { :joins => :car, :conditions => ["cars.year = ?", year] } }
  named_scope :fueled, lambda { |fuel| { :joins => :car, :conditions => ["cars.fuel = ?", fuel] } }
  named_scope :service_typed, lambda { |service_type| { :conditions => ["service_type_id = ?", service_type] } }

end
