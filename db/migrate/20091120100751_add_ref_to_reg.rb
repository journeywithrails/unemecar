class AddRefToReg < ActiveRecord::Migration
  def self.up
  	add_column :event_registrations, :refered_by, :string
  end

  def self.down
  end
end
