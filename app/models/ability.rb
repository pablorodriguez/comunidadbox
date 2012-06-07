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
    user ||= User.new

    can :manage, Car do |car|
      car.user == user || user.can_edit?(car.user)
    end

    can :read, Car do |car|
      car.user == user || user.company
    end

    if user.is_super_admin?
      can :manage, Material
      can :manage, :conf
      can :manage, Task
      can :manage, ServiceType
      can :manage, Brand
      can :manage, Model
      can :manage, State      
    elsif user.id
      can :details, Material      
    end 

    can :create, Workorder do |w|
      value = (w.company.is_employee(user)) ? true :false

      unless value
        value = (w.car.user == user)
      end
      
      value
    end
  
    can [:update,:destroy], Workorder do |w|
      w.car.user == user || w.can_edit?(user)
    end

    can :read, Workorder do |w|
      w.car.user == user || w.can_show?(user)
    end

    can :read, Budget do |b|
      (b.car && b.car.user == user) || b.user == user || Company.is_employee?(b.creator.get_companies_ids,user)
    end

    can [:destroy,:update], Budget do |b|      
      Company.is_employee?(b.creator.get_companies_ids,user)
    end

     
    if user.has_company? || user.is_employee?
      can :manage, :control_panel
      can :create, Budget
      can :manage, Company
      can :manage, :client
      #can :index_all, :client
    end

    can :read, Company
    can :all, Company
    can :search_distance, Company
    can :index, ServiceOffer

    if user.is_administrator? || user.is_manager?
      can :manage, ServiceOffer
      can :manage, :admin
      can :manage, PriceList
      can :manage, :employee
      can :manage, ServiceFilter      
    end


  end
end
