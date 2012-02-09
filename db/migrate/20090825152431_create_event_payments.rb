class CreateEventPayments < ActiveRecord::Migration
  def self.up
    create_table :event_payments do |t|
		t.column :event_id, :integer
		t.column :amount, :double
		t.column :date, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :event_payments
  end
end
