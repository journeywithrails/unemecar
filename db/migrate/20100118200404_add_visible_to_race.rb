class AddVisibleToRace < ActiveRecord::Migration
  def self.up
  	add_column :races, :visible, :boolean
  end

  def self.down
  end
end
