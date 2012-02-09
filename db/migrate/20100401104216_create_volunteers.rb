class CreateVolunteers < ActiveRecord::Migration
  def self.up
    create_table :volunteers do |t|
    	t.column :last_name, :string
		t.column :first_name, :string
		t.column :birthday, :date
		t.column :email, :string
		t.column :phone, :string
		t.column :address, :string
		t.column :apt, :string
		t.column :city, :string
		t.column :state, :string
		t.column :zip, :string
		t.column :comments, :string
		t.column :gender, :string
		t.column :volunteer_job_id, :integer
		t.column :event_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :volunteers
  end
end
