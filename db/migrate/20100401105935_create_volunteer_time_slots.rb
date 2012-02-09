class CreateVolunteerTimeSlots < ActiveRecord::Migration
  def self.up
    create_table :volunteer_time_slots do |t|
    	t.column :start_time, :datetime
    	t.column :end_time, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :volunteer_time_slots
  end
end
