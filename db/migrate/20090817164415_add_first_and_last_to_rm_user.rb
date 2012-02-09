class AddFirstAndLastToRmUser < ActiveRecord::Migration
  def self.up
  	add_column :rm_users, :first_name, :string
    add_column :rm_users, :last_name, :string
  end

  def self.down
  end
end
