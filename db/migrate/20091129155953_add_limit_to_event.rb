class AddLimitToEvent < ActiveRecord::Migration
  def self.up
  	add_column :events, :entry_limit, :int
  end

  def self.down
  end
end
