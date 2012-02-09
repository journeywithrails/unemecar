class CreateRegistrationDatas < ActiveRecord::Migration
  def self.up
    create_table :registration_datas do |t|
		t.column :event_registration_id, :integer
      t.timestamps
      
      #add event_id column to event reg
    end
  end

  def self.down
    drop_table :registration_datas
  end
end
