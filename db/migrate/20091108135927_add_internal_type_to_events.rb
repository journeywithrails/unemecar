class AddInternalTypeToEvents < ActiveRecord::Migration
  def self.up
  	add_column :events, :manage_type, :int
  end

  def self.down
  end
end
