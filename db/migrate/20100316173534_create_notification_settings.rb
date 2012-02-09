class CreateNotificationSettings < ActiveRecord::Migration
  def self.up
    create_table :notification_settings do |t|
      t.integer :event_id, :null => false
      t.boolean :rec_reg_notification, :default => false
      t.boolean :rec_daily_notification, :default => false
      t.string :notification_email
      t.timestamps
    end
  end

  def self.down
    drop_table :notification_settings
  end
end
