class EnhancePayments < ActiveRecord::Migration
  def self.up
      add_column :event_payments, :check_number, :string
      add_column :event_payments, :notes, :text
  end

  def self.down
  end
end
