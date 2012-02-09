class RenameArmailerTable < ActiveRecord::Migration
  def self.up
	  rename_table :r_notifiers, :r_notifier_emails
  end

  def self.down
	  rename_table :r_notifier_emails, :r_notifiers
  end
end
