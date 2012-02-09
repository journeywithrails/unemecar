class AddApprovalEmailNotificationToTeams < ActiveRecord::Migration
  def self.up
      add_column :races, :supports_team_creation, :boolean
  end

  def self.down
  end
end
