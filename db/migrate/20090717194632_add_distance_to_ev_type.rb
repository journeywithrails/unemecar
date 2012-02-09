class AddDistanceToEvType < ActiveRecord::Migration
  def self.up
  	add_column :event_types, :distance, :float
  end

  def self.down
  end
end
