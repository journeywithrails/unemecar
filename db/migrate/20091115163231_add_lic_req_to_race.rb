class AddLicReqToRace < ActiveRecord::Migration
  def self.up
  	add_column :races, :license_req, :boolean
  end

  def self.down
  end
end
