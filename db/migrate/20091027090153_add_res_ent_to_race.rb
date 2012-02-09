class AddResEntToRace < ActiveRecord::Migration
  def self.up
  	add_column :races, :reserve_entries, :string
  end

  def self.down
  end
end
