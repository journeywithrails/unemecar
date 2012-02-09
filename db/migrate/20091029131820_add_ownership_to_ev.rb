class AddOwnershipToEv < ActiveRecord::Migration
  def self.up
  	add_column :events, :owner_id, :int
  end

  def self.down
  end
end
