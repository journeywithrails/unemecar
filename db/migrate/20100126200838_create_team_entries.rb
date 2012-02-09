class CreateTeamEntries < ActiveRecord::Migration
  def self.up
    create_table :team_entries do |t|
    	t.column :team_id, :integer
    	t.column :team_order, :integer
    	t.column :approved, :boolean
    	t.column :event_registration_id, :integer
      t.timestamps
    end
    #refactor the team table
    add_column :teams, :cpt_first_name, :string
    add_column :teams, :cpt_last_name, :string
    
  end

  def self.down
    drop_table :team_entries
  end
end
