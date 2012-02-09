class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
		t.column :race_director_id, :integer
		t.column :name, :string
		t.column :company_name, :string
		t.column :captain_name, :string
		t.column :email, :string
		t.column :phone, :string
		t.column :address, :string
		t.column :apt, :string
		t.column :city, :string
		t.column :state, :string
		t.column :zip, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
