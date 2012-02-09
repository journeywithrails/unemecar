class AddClubToReg < ActiveRecord::Migration
  def self.up
  	add_column :event_registrations, :club_team, :string
  end

  def self.down
  end
end
