class EnhanceEventWithVol < ActiveRecord::Migration
  def self.up
  	add_column :events, :supports_volunteer, :boolean, :default => false
  end

  def self.down
  end
end
