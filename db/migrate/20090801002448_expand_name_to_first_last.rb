class ExpandNameToFirstLast < ActiveRecord::Migration
  def self.up
    remove_column :event_registrations, :name
    add_column :event_registrations, :first_name, :string
    add_column :event_registrations, :last_name, :string
  end

  def self.down
    add_column :event_registrations, :name, :string
    remove_column :event_registrations, :first_name
    remove_column :event_registrations, :last_name
  end
end