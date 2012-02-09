class AddExtraFieldsToReg < ActiveRecord::Migration
  def self.up
  	add_column :event_registrations, :payment_notes, :string
  	add_column :event_registrations, :age, :int
  end

  def self.down
  end
end
