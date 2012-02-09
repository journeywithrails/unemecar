class AddTempFieldsToReg < ActiveRecord::Migration
  def self.up
  	add_column :event_registrations, :first_tri, :string
  	add_column :event_registrations, :open_swim, :string
  end

  def self.down
  end
end
