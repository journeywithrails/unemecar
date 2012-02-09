class AddRefundProcToEreg < ActiveRecord::Migration
  def self.up
  	add_column :event_registrations, :refund_processed, :boolean
  end

  def self.down
  end
end
