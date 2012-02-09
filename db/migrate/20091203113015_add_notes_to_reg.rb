class AddNotesToReg < ActiveRecord::Migration
  def self.up
  	add_column :event_registrations, :general_notes, :string
  end

  def self.down
  end
end
