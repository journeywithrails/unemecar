class AddApprovedToEvent < ActiveRecord::Migration
  def self.up
  	add_column :events, :approved, :boolean, :default => 1
  end

  def self.down
  end
end
