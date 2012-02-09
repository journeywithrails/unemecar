class ExtendRacesWExtraAttribs < ActiveRecord::Migration
  def self.up
  	add_column :races, :is_kids_race, :boolean
  	add_column :races, :is_sanctioned, :boolean
  	add_column :races, :is_series, :boolean
  	add_column :races, :sanctioned_by, :string
  	add_column :races, :series_name, :string
  end

  def self.down
  end
end
