class Advertisement < ActiveRecord::Base
  attr_accessible :service_offer_id,:advertisement_days_attributes

  belongs_to :service_offer
  has_many :advertisement_days

  accepts_nested_attributes_for :advertisement_days,:allow_destroy => true

  def self.search_by_date today
    Advertisement.includes("advertisement_days").group("advertisement_days.published_on").all
  end

  def self.weeks(date = Date.today)
    first = date.beginning_of_month.beginning_of_week(:sunday)
    last = date.end_of_month.end_of_week(:sunday)
    (first..last).to_a.in_groups_of(7)
  end

  def self.weeks_to_json(date= Date.today)
    weeks = self.weeks(date)
    Jbuilder.encode do |json| 
      json.array! weeks do |week|
        json.array! week do |day|
          json.day day.day
          json.date day
          json.today date == day
          json.notmonth date.month != day.month
        end
      end
    end
  end

end
