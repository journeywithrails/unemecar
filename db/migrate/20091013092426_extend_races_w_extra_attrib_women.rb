class ExtendRacesWExtraAttribWomen < ActiveRecord::Migration
  def self.up
  	add_column :races, :is_women_race, :boolean
  end

  def self.down
  end
end
