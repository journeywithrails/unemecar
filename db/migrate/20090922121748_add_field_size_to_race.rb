class AddFieldSizeToRace < ActiveRecord::Migration
  def self.up
  	add_column :races, :field_size, :integer
  end

  def self.down
  end
end
