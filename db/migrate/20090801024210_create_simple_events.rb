class CreateSimpleEvents < ActiveRecord::Migration
  def self.up
    create_table :simple_events do |t|
      t.string :title
      t.datetime :date
      t.string :host
      t.string :discipline
      t.string :event_type
      t.text :description
      t.string :location
      t.string :city
      t.string :state
      t.string :contact_name
      t.string :contact_email
      t.string :website

      t.timestamps
    end
  end

  def self.down
    drop_table :simple_events
  end
end
