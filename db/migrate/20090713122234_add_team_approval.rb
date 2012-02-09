class AddTeamApproval < ActiveRecord::Migration
  def self.up
  	add_column :teams, :approved, :boolean
  end

  def self.down
  end
end
