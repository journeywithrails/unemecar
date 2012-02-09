class AddTeamSupportToRegType < ActiveRecord::Migration
  def self.up
  	add_column :registration_entry_types, :supports_teams, :boolean
  	add_column :events, :is_register_open, :boolean
  end

  def self.down
  end
end
