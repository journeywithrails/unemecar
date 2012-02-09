class UseRacesInsteadOfRegTypeInRegEntries < ActiveRecord::Migration
  def self.up
  	add_column :event_registrations, :race_id, :integer
  end

  def self.down
  end
end
