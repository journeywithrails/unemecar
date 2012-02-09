class CreateVolunteerJobs < ActiveRecord::Migration
  def self.up
    create_table :volunteer_jobs do |t|
    	t.column :title, :string
    	t.column :location, :string
    	t.column :start_time, :datetime
    	t.column :end_time, :datetime
    	t.column :training_info, :text
    	t.column :training_start_time, :datetime
    	t.column :training_end_time, :datetime
    	t.column :training_location, :string
    	t.column :min_needed, :integer
    	t.column :max_needed, :integer
		t.column :event_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :volunteer_jobs
  end
end
