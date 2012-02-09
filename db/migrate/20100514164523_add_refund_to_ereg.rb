class AddRefundToEreg < ActiveRecord::Migration
  def self.up
  	add_column :event_registrations, :refund_amount, :float
  end

  def self.down
  end
end
