class AddHeaderToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :header_image_id, :integer
  end

  def self.down
    remove_column :events, :header_image_id
  end
end
