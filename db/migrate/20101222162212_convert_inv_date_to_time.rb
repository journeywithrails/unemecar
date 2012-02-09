class ConvertInvDateToTime < ActiveRecord::Migration
  def self.up
    change_column :invitations, :expire_at, :datetime
    change_column :invitations, :used_at, :datetime
  end

  def self.down
  end
end
