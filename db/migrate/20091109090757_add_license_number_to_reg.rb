class AddLicenseNumberToReg < ActiveRecord::Migration
  def self.up
  	add_column :event_registrations, :license_num, :string
  end

  def self.down
  end
end
