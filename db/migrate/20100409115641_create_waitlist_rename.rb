class CreateWaitlistRename < ActiveRecord::Migration
  def self.up
	  rename_table :watchlists, :waitlists
  end

  def self.down
	  rename_table :waitlists, :watchlists
  end
end
