class CreateSeriesEvents < ActiveRecord::Migration
  def self.up
    create_table :series_events do |t|
      t.column :series_id,:integer
      t.column :event_id,:integer
      t.timestamps
    end
  end

  def self.down
    drop_table :series_events
  end
end
