class AddIpToReg < ActiveRecord::Migration
  def self.up
  	add_column :event_registrations, :ip_address, :string
  end

  def self.down
  end
end
