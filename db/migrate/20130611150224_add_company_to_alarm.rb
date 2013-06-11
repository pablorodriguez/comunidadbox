class AddCompanyToAlarm < ActiveRecord::Migration
  def change
    add_column :alarms, :company_id, :integer
    add_foreign_key(:alarms,:companies)

    Alarm.all.each do |alarm|
      if alarm.user.company_id
        alarm.company_id = alarm.user.company_id
        alarm.save
      end
    end
  end
end
