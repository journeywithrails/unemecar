class CreateVolunteerCoords < ActiveRecord::Migration
  def self.up
    create_table :volunteer_coords do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :volunteer_coords
  end
end
