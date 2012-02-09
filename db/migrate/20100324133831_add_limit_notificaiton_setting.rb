class AddLimitNotificaitonSetting < ActiveRecord::Migration
  def self.up
  	add_column :notification_settings, :rec_limit_notification, :boolean
  end

  def self.down
	  remove_column :notification_settings, :rec_limit_notification
  end
end
