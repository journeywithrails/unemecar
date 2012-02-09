class EnhanceRegistrations < ActiveRecord::Migration
  def self.up
  	#add sex, invoice, and verified columns
  	add_column :event_registrations, :sex, :string
  	add_column :event_registrations, :invoice_code, :string
  	add_column :event_registrations, :processed, :boolean
  end

  def self.down
  end
end
