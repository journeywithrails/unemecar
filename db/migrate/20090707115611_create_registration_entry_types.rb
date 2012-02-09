class CreateRegistrationEntryTypes < ActiveRecord::Migration
  def self.up
    create_table :registration_entry_types do |t|
		t.column :event_id, :integer
		t.column :name, :string
		t.column :cost, :float
		
      t.timestamps
    end
  end

  def self.down
    drop_table :registration_entry_types
  end
end
