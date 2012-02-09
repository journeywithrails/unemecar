class AddTeamSupportToRace < ActiveRecord::Migration
  def self.up
      add_column :races, :supports_team, :boolean
  end

  def self.down
  end
end
