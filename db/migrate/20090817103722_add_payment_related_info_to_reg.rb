class AddPaymentRelatedInfoToReg < ActiveRecord::Migration
  def self.up
  	add_column :event_registrations, :registration_entry_type_id, :int
  	add_column :event_registrations, :status, :string
  end

  def self.down
  end
end
