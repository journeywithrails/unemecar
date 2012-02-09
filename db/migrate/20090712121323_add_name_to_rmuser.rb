class AddNameToRmuser < ActiveRecord::Migration
  def self.up
  	add_column :rm_users, :name, :string
  end

  def self.down
  end
end
