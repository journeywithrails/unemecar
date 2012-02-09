class AddMultipleEventTypes < ActiveRecord::Migration
  
  def self.up
    create_table :event_types_events, :id => false do |t|
      t.integer :event_id
      t.integer :event_type_id
    end
  end

  def self.down
    drop_table :event_types_events
  end
  
end
