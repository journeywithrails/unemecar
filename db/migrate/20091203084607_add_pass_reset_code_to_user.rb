class AddPassResetCodeToUser < ActiveRecord::Migration
  def self.up
  	add_column "rm_users", "password_reset_code", :string, :limit => 40
  end

  def self.down
  end
end
