class CreateEventRegistrations < ActiveRecord::Migration
  def self.up
    create_table :event_registrations do |t|
    	t.column :rm_user_id, :integer
		t.column :name, :string
		t.column :birthday, :date
		t.column :team_id, :integer
		t.column :email, :string
		t.column :phone, :string
		t.column :address, :string
		t.column :apt, :string
		t.column :city, :string
		t.column :state, :string
		t.column :zip, :string
		t.column :em_con_name, :string
		t.column :em_con_phone, :string
		t.column :em_con_relationship, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :event_registrations
  end
end
