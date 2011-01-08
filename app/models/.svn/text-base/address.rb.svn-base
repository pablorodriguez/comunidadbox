class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  belongs_to :state
  
  def to_text
    "#{state.country.name} #{state.name} #{city} #{street}"
  end
end
