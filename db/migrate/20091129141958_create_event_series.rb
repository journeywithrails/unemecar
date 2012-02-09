class CreateEventSeries < ActiveRecord::Migration
  def self.up
    create_table :event_series do |t|
		t.column :name, :string
		t.column :rm_user_id, :int
		
      t.timestamps
    end
    #add column to events
    add_column :events, :event_series_id, :int
  end

  def self.down
    drop_table :event_series
  end
end
