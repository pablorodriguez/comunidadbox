class Event < ActiveRecord::Base
  belongs_to :service_type
  belongs_to :car
  belongs_to :service
  belongs_to :service_done,:class_name =>"Service"

  MONTHS_IN_SEC = 60 * 60 * 24 * 30
  MONTH_RED=1
  MONTH_YELLOW=2
  MONTH_GREEN=2
 
  scope :red, lambda {{:conditions => ["dueDate <= ?", Time.now.months_since(Event::MONTH_RED)]} }
  scope :yellow, lambda {{:conditions => ["dueDate > ? AND dueDate <= ?",Time.now.months_since(Event::MONTH_RED), Time.now.months_since(Event::MONTH_YELLOW)]} }
  scope :green, lambda {{:conditions => ["dueDate > ? ",Time.now.months_since(Event::MONTH_GREEN)]} }

  scope :modeled, lambda { |model| { :joins => :car, :conditions =>  ["cars.model_id = ?", model] } }
  scope :branded, lambda { |brand| { :joins => :car, :conditions =>  ["cars.brand_id = ?", brand] } }
  scope :yeared, lambda { |year| { :joins => :car, :conditions => ["cars.year = ?", year] } }
  scope :fueled, lambda { |fuel| { :joins => :car, :conditions => ["cars.fuel = ?", fuel] } }
  scope :service_typed, lambda { |service_type| { :conditions => ["service_type_id = ?", service_type] } }
  scope :car,lambda{|car_id| {:joins=>:car,:conditions =>["cars.id = ?",car_id]}}
  
  def is_green
    dueDate > Time.now.months_since(Event::MONTH_YELLOW).to_date ? true : false
  end
  
  def is_yellow
    dueDate > Time.now.months_since(Event::MONTH_RED).to_date && dueDate <= Time.now.months_since(Event::MONTH_YELLOW).to_date ? true : false
  end
  
  def is_red
    dueDate <= Time.now.months_since(Event::MONTH_RED).to_date ? true : false 
  end

end
