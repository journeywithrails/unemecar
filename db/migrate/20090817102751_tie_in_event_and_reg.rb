class TieInEventAndReg < ActiveRecord::Migration
  def self.up
  	add_column :event_registrations, :event_id, :int
  end

  def self.down
  end
end
