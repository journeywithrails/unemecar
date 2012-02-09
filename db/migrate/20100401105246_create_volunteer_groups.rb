class CreateVolunteerGroups < ActiveRecord::Migration
  def self.up
    create_table :volunteer_groups do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :volunteer_groups
  end
end
