# encoding: utf-8
class ServiceOffer < ActiveRecord::Base
  include Statused
  attr_accessible :offer_service_types_attributes, :service_type_id, :title, :status, :comment, :price, :percent,:service_type, :final_price, :since, :until, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :offer_service_types,:company_id,:service_request_id,:advertisement_attributes

  has_many :vehicle_service_offers
  has_many :vehicles, :through => :vehicle_service_offers
  has_many :offer_service_types
  has_many :service_types,:through => :offer_service_types
  has_many :advertisement_days,:through => :advertisement
  has_one :advertisement
  belongs_to :company
  belongs_to :service_request


  validates_numericality_of :price,:final_price,:percent
  validates_presence_of :title, :price, :final_price, :percent
  accepts_nested_attributes_for :offer_service_types,:reject_if => lambda { |m| m[:service_type_id].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :advertisement,:allow_destroy => true

  default_scope {order("service_offers.created_at DESC")}
  scope :sended ,where("service_offers.status = ?",Status::SENT)
  scope :confirmed, where("service_offers.status = ?",Status::CONFIRMED)
  scope :vehicles, lambda{|vehicles_ids| where("vehicle_service_offers.vehicle_id in (?)",vehicles_ids).includes(:vehicle_service_offers)}
  validate :validate_service_types

  after_initialize :custom_init

  def custom_init
    if vehicle_service_offers.empty? and advertisement.nil?
      build_advertisement
    end
  end


  def validate_service_types
    errors.add(:service_types, "debe tener al menos un tipo de servicio") if offer_service_types.length == 0
  end

  def build_offer_service_types service_types
    service_types.each do |st|
      if company_id
        c = Company.find company_id
        if c.perform_service_type?(st)
          self.offer_service_types.build(service_type: st)
        end
      end
    end
  end

  def service_types_names
    offer_service_types.map{|ost| ost.service_type.name}.join(" - ")
  end

  def valid_dates
    days = []
    days << "sunday" if self.sunday
    days << "monday" if self.monday
    days << "tuesday" if self.tuesday
    days << "wednesday" if self.wednesday
    days << "thursday" if self.thursday
    days << "friday" if self.friday
    days << "saturday" if self.saturday
    days
  end

  def my_vehicles user
    vehicle_service_offers.select{|cs| cs.vehicle.user.id == user.id}
  end

  #Busco las ofertas de servicio y las agrupo por auto
  def self.get_service_offer_by_user
    vehicles = Hash.new
    service_offers = ServiceOffer.confirmed

    service_offers.each do |s|
      s.vehicles.each do |c|
        unless vehicles[c]
          vehicles[c]=Array.new
        end
        vehicles[c] << sremove_advertisement_entity
      end
    end

    return vehicles,service_offers
  end

  #if user's car belong to service offer car the user can see it
  def can_show? user
    unless self.advertisement_days.empty?
      return true
    end
    vehicles_ids = user.vehicles.map(&:id)
    VehicleServiceOffer.where("service_offer_id = ? and vehicle_id IN(?)",self.id,vehicles_ids).count > 0
  end

  def can_delete? user
     user.is_employee? && status != Status::SENT
   end

  #Notifico a los autos sus ofertas de servicios
  def self.notify
    #enviar solo a estos autos..prueba
    vehicles_id = %w"HRJ549 AOK780"
    logger.info "Service Offer notify"
    vehicles,so = get_service_offer_by_user
    vehicles.each do |vehicle,service_offers|
      #if vehicles_id.include?(vehicle.domain)
        ServiceOffer.transaction do
          self.notify_service_offer(vehicle,service_offers)
          self.update_vehicle_service_offer_status(vehicle,service_offers)
        end
      #end
    end

    #Actualizo el estado de cada Oferta de Servicio a SENT
    so.each {|s| s.update_attributes(status: Status::SENT)}

  end

  #Actualizo el estado de la oferta de servicio del auto a SENT
  def self.update_vehicle_service_offer_status(vehicle,service_offers)
    service_offers.each do |so|
      VehicleServiceOffer.where("vehicle_id = ? and service_offer_id = ?",vehicle.id,so.id).update_all(status: Status::SENT)
    end
  end

  def self.weeks(date = Date.today)
    first = date.beginning_of_week(:sunday)

    last = (first + 30).end_of_week(:sunday)
    (first..last).to_a.in_groups_of(7)
  end

  def self.today_advertisements
    advertisements_for_day Date.today
  end

  def self.advertisements_for_day day
    ServiceOffer.confirmed.includes("advertisement_days").where("advertisement_days.published_on = ?",day)
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


  def to_builder
    date = Date.today

    #create service offer object
    Jbuilder.encode do |json|
      json.id self.id
      json.price self.price
      json.percent self.percent
      json.final_price self.final_price
      json.offer_service_types self.offer_service_types do |ost|
        json.id ost.id
        json.service_type_id ost.service_type.id
        json.name ost.service_type.name
        json.show true
      end

      days_with_ad = Hash.new

      if advertisement
        #create advertisement object

        json.advertisement do
          json.id self.advertisement.id

          #create advertisement days for the service object
          json.advertisement_days self.advertisement.advertisement_days do |ad_day|
            ad = days_with_ad[ad_day.published_on.to_s] || Hash.new
            ad[ad_day.advertisement.id] = ad_day
            days_with_ad[ad_day.published_on.to_s] = ad

            json.advertisement_id ad_day.advertisement_id
            json.id ad_day.id
            json.published_on ad_day.published_on
          end
        end

        #create calendar's weeks
        weeks_values = ServiceOffer.weeks

        Advertisement.search_other_by_weeks(self,weeks_values).each do |ad|
          ad.advertisement_days.each do |ad_day|
            ad = days_with_ad[ad_day.published_on.to_s] || Hash.new
            ad[ad_day.advertisement.id] = ad_day
            days_with_ad[ad_day.published_on.to_s] = ad
          end
        end

        json.weeks weeks_values do |week|
          json.array! week do |day|
            json.day day.day
            json.date day
            json.today date == day
            json.notmonth date.month != day.month

            day_ad = days_with_ad[day.to_s] || Hash.new
            nro = day_ad.keys.size

            if (date > day) || (nro >=3)
              json.can_no_ad_add true
            else
              json.can_no_ad_add false
            end

            json.ad_nro (nro > 0) ? nro : 0
            json.my_ad (nro > 0) ? true : false
            json.has_ad (nro > 0) ? true : false

            ads = (1..3).to_a

            json.ads do
              json.array! ads do |index|
                if days_with_ad[day.to_s]
                  temp = days_with_ad[day.to_s].values[index-1]
                  json.other_add true if (temp && (temp.advertisement.service_offer.id != self.id))
                  if (temp && (temp.advertisement.service_offer.id == self.id))
                    json.my_ad true
                    json.so self.id
                    json.advertisement_id temp.advertisement.id
                  end
                end
                json.has_ad (index <= nro ? true : false)
              end
            end
          end
        end
      end

    end
  end

  private

  def self.notify_service_offer(vehicle,service_offers)
    logger.info "Envio de ServiceOffer #{Time.zone.now} para #{vehicle.domain} #{service_offers.map(&:id).join(',')}"
    message = ServiceOfferMailer.notify(vehicle,service_offers).deliver
  end
end

