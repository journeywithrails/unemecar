class AddMinimumAgeToRace < ActiveRecord::Migration
  def self.up
  	add_column :races, :has_minimum_age, :boolean
  	add_column :races, :minimum_age, :int
  end

  def self.down
  end
end
