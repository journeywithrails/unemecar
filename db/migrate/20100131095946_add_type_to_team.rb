class AddTypeToTeam < ActiveRecord::Migration
  def self.up
      add_column :teams, :team_type, :string
      add_column :event_registrations, :team_type, :string
  end

  def self.down
  end
end
