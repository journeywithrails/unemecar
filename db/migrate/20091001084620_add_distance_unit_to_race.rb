class AddDistanceUnitToRace < ActiveRecord::Migration
  def self.up
  	add_column :races, :distance_unit, :int
  end

  def self.down
  end
end
