class AddManualTypeRegEntry < ActiveRecord::Migration
  def self.up
  	add_column :event_registrations, :is_manual, :boolean
  end

  def self.down
  end
end
