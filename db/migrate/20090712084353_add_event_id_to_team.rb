class AddEventIdToTeam < ActiveRecord::Migration
  def self.up
  	add_column :teams, :event_id, :int
  end

  def self.down
  end
end
