class RemoveDisciplineIdFromEventModel < ActiveRecord::Migration
  def self.up
    remove_column :events, :discipline_id
  end
  def self.down
    add_column :events, :discipline_id, :integer
  end
end