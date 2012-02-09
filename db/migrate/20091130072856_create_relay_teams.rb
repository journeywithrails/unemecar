class CreateRelayTeams < ActiveRecord::Migration
  def self.up
    create_table :relay_teams do |t|
		t.column :event_registration_id, :integer
		t.column :name, :string
		t.column :division, :string
      t.timestamps
    end
    #remove the ev reg id from relay entry
    remove_column :relay_entries, :event_registration_id
    add_column :relay_entries, :relay_team_id, :int
    add_column :relay_entries, :gender, :string
    add_column :relay_entries, :tshirt, :string
  end

  def self.down
    drop_table :relay_teams
  end
end
