class AddPriceInfoToEReg < ActiveRecord::Migration
  def self.up
  	add_column :event_registrations, :cost, :float
  	add_column :event_registrations, :service_fee, :float
  end

  def self.down
  end
end
