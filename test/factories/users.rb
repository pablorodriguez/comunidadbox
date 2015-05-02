FactoryGirl.define do

  factory :gustavo_de_antonio, class: User do
    id 4
    first_name "Gustavo"
    last_name "De Antonio"
    email "gustavo@comunidadbox.com"    
    password "gustavotest"
    password_confirmation "gustavotest"
    confirmed 1
    confirmed_at 1.months.ago
    roles {[Role.find(5)]}
    after(:build) do |user|
      user.companies << FactoryGirl.build(:valle_grande_mendoza_peru)
      user.companies << FactoryGirl.build(:valle_grande_mendoza_plaza)      
    end
  end

  factory :emp_walter,class: User do
    first_name "Walter"
    last_name "Martinez"
    email "walter@vgneumaticos.com.ar"
    password "waltertest"
    password_confirmation "waltertest"
    confirmed 1
    confirmed_at 1.months.ago
    roles {[create(:employee)]}
    employer {Company.find(1)}
    creator {User.find(4)}
  end

  factory :imr_admin, class: User do
    first_name "imr"
    last_name "imr"
    email "imr@comunidadbox.com"    
    password "imrtest"
    password_confirmation "imrtest"
    confirmed 1    
    confirmed_at 1.months.ago
    after(:build) do |user|
      user.companies << FactoryGirl.build(:imr)      
    end
    roles {[Role.find(5)]}
  end 

  factory :imr_emp, class: User do
    first_name "Marcelo"
    last_name "Battle"
    email "marcelo_battle2@comunidadbox.com"    
    password "marcelotest"
    password_confirmation "marcelotest"
    confirmed 1   
    confirmed_at 1.months.ago     
    roles {[Role.find(5)]}
    employer {Company.find(3)}
  end 

  factory :marcelo_de_antonio, class: User do
    first_name "Marcelo"
    last_name "De Antonio"
    email "marcelo@comunidadbox.com"    
    password "marcelotest"
    password_confirmation "marcelotest"
    confirmed 1
    confirmed_at 1.months.ago  
    roles {[Role.find(5)]}
    employer {Company.find(1)}
    creator {User.find(4)}
  end

  factory :pablo_rodriguez,class: User do
    first_name "Pablo"
    last_name "Rodriguez"
    email "pablo@comunidadbox.com"
    password "pablotest"
    password_confirmation "pablotest"
    encrypted_password "$2a$10$ChJ3cHXqLk.mgopoKrfiL.vv414pZMUQFHGWarGO95ehfpWrWCn8G"
    password_salt "$2a$10$ChJ3cHXqLk.mgopoKrfiL."
    confirmed 1
    confirmed_at 1.months.ago
    
    vehicles {[FactoryGirl.build(:HRJ549), FactoryGirl.build(:m549HRJ)]}
    
  end

  factory :new_pablo_rodriguez,class: User do
    first_name "Pablo"
    last_name "Rodriguez"
    email "pablorodriguez.ar@hotmail.com"
    password "pablotest"
    password_confirmation "pablotest"
    encrypted_password "$2a$10$ChJ3cHXqLk.mgopoKrfiL.vv414pZMUQFHGWarGO95ehfpWrWCn8G"
    password_salt "$2a$10$ChJ3cHXqLk.mgopoKrfiL."    
    after(:build) do |user|
      user.vehicles << FactoryGirl.create(:HRJ999)
    end
  end


  factory :hugo_rodriguez,class: User do
    first_name "Hugo"
    last_name "Rodriguez"
    email "hugo@rodriguez.com"
    password "hugotest"
    password_confirmation "hugotest"
    encrypted_password "$2a$10$ChJ3cHXqLk.mgopoKrfiL.vv414pZMUQFHGWarGO95ehfpWrWCn8G"
    password_salt "$2a$10$ChJ3cHXqLk.mgopoKrfiL."
    confirmed 1
    confirmed_at 1.months.ago
    after(:build) do |user|
      user.vehicles << FactoryGirl.create(:DDD549)
    end
  end

end