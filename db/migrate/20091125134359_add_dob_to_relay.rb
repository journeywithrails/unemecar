class AddDobToRelay < ActiveRecord::Migration
  def self.up
  	add_column :relay_entries, :date_of_birth, :date
  	add_column :relay_entries, :email, :string
  	add_column :relay_entries, :license_num, :string
  end

  def self.down
  end
end
