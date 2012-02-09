class ExtendRacesWithFeeInfo < ActiveRecord::Migration
  def self.up
  	add_column :races, :prizes, :string
  	add_column :races, :assign_bibs, :boolean
  	add_column :races, :registration_open, :boolean
  end

  def self.down
  end
end
