class AddIndexesToEreg < ActiveRecord::Migration
  def self.up
    add_index :event_registrations, :rm_user_id
    add_index :event_registrations, :event_id
  end

  def self.down
  end
end
