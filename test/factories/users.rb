FactoryGirl.define do

  factory :gustavo_de_antonio, class: User do
    first_name "Gustavo"
    last_name "De Antonio"
    email "gustavo@comunidadbox.com"    
    password "gustavotest"
    confirmed 1
    roles {[create(:administrator)]}
    after_build do |user|
      user.companies << FactoryGirl.build(:valle_grande_mendoza_peru)
      user.companies << FactoryGirl.build(:valle_grande_mendoza_plaza)      
    end
  end

  factory :emp_walter,class: User do
    first_name "Walter"
    last_name "Martinez"
    email "walter@vgneumaticos.com.ar"
    password "waltertest"
    confirmed 1
    roles {[create(:employee)]}
  end


  factory :marcelo_de_antonio, class: User do
    first_name "Marcelo"
    last_name "De Antonio"
    email "marcelo@comunidadbox.com"    
    password "marcelotest"
    confirmed 1
    employer factory: :valle_grande_mendoza_plaza
    creator factory: :gustavo_de_antonio
    after_build do |user|    
      user.roles {[create(:administrator)]}
    end
  end

  factory :pablo_rodriguez,class: User do
    first_name "Pablo"
    last_name "Rodriguez"
    email "pablo@comunidadbox.com"
    password "pablotest"
    encrypted_password "$2a$10$ChJ3cHXqLk.mgopoKrfiL.vv414pZMUQFHGWarGO95ehfpWrWCn8G"
    password_salt "$2a$10$ChJ3cHXqLk.mgopoKrfiL."
    confirmed 1
    after_build do |user|
      user.cars << FactoryGirl.create(:HRJ549)
    end
  end

  factory :hugo_rodriguez,class: User do
    first_name "Hugo"
    last_name "Rodriguez"
    email "hugo@rodriguez.com"
    password "pablotest"
    encrypted_password "$2a$10$ChJ3cHXqLk.mgopoKrfiL.vv414pZMUQFHGWarGO95ehfpWrWCn8G"
    password_salt "$2a$10$ChJ3cHXqLk.mgopoKrfiL."
    confirmed 1
    after_build do |user|
      user.cars << FactoryGirl.create(:DDD549)
    end
  end

end