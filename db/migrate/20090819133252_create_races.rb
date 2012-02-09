class CreateRaces < ActiveRecord::Migration
  def self.up
    create_table :races do |t|
		t.column :event_id, :integer
		t.column :discipline_id, :integer
		t.column :event_type_id, :integer
		t.column :distance, :float
		t.column :start_time, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :races
  end
end
