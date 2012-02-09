class AddPaymentGross < ActiveRecord::Migration
  def self.up
  	
  	add_column :event_registrations, :payment_gross, :string
  end

  def self.down
  end
end
