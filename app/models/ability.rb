# encoding: utf-8
class Ability
  include CanCan::Ability
  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
    can :read, Company
    can :all, Company
    can :manage, :contact
    can :search_distance, Company
    can :search, Company
    can :index, ServiceOffer

    user ||= User.new

    can :manage, Vehicle do |vehicle|
      vehicle.user == user || user.can_edit?(vehicle.user)
    end

    can :read, Vehicle do |vehicle|
      user.can_read?(vehicle.user)
    end

    can :destroy, Vehicle do |c|
      user.can_edit?(c.user)
    end

    can [:destroy,:update], User do |client|
      user.can_edit?(client)
    end

    can :read,User do |client|
      user.close_system ?  user.can_read?(client) : true
    end

    if user.is_super_admin?
      can :manage, :conf
      can :manage, Task
      #can :manage, ServiceType
      can :manage, State
      can :manage, ServiceOffer
    elsif user.id
      can :manage, Material
      can :details, Material
    end

    can :create, Workorder do |w|
      value = (w.company && w.company.is_employee?(user)) ? true :false

      unless value
        value = (w.vehicle.user == user)
      end

      value
    end

    can [:update], ServiceRequest do |sr|
      sr.can_edit? user
    end

    can [:destroy], ServiceRequest do |sr|
      sr.can_delete? user
    end

    can :show_ad,ServiceOffer do |s|
      true
    end

    can :read,ServiceOffer do |s|
      s.can_show? user
    end

    can :update,ServiceOffer do |so|
      so.can_edit? user
    end

    can :destroy,ServiceOffer do |so|
      so.can_delete? user
    end

    can :confirm,ServiceOffer do |s|
      s.can_confirm? user
    end

    can [:update,:destroy], Workorder do |w|
      w.user == user || w.can_edit?(user)
    end

    can :read, Workorder do |w|
      w.vehicle.user == user || user.is_employee?
    end

    can :read, VehicleServiceOffer do |cso|
      if user.company
        cso.service_offer.company == user.company
      else
        user.own_vehicle(cso.vehicle)
      end
    end

    can :pdf, Workorder do |w|
      w.can_show_pdf? user
    end

    can :print,Workorder do |w|
      w.can_print_pdf? user
    end

    can :read, Budget do |b|
      b.can_show?(user)
    end

    can [:destroy,:update], Budget do |b|
      Company.is_employee?(b.creator.get_companies_ids,user.id)
    end

    can [:destroy,:update],ServiceTypeTemplate do |t|
      Company.is_employee?([t.company_id],user.id)
    end

    if user.has_company? || user.is_employee?
      can :manage, :control_panel
      can :create, Budget
      can :manage, Company
      can :index, :client
      can :manage, Brand
      can :manage, Model
    end

    if user.is_administrator? || user.is_manager?
      can :manage, ServiceOffer
      can :manage, :admin
      #can :manage, PriceList
      can :manage, :employee
      can :manage, ServiceFilter
      can :manage, Export
    end

    can [:import,:read], PriceList do |pl|
      pl.can_edit?(user) && (user.is_administrator? || user.is_manager?)
    end
 
    if user.is_super_admin?
      can :manage, Resque
    end

  end
end
