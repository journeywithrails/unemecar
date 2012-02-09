class AddGenderToTi4K < ActiveRecord::Migration
  def self.up
    add_column :event_registrations, :tshirt, :string
  end

  def self.down
    remove_column :event_registrations, :tshirt
  end
end
