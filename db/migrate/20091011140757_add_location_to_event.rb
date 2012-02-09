class AddLocationToEvent < ActiveRecord::Migration
  def self.up
  	add_column :events, :location, :string
  end

  def self.down
  end
end
