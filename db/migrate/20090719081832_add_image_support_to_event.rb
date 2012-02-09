class AddImageSupportToEvent < ActiveRecord::Migration
  def self.up
  	add_column :events, :content_type, :string
    add_column :events, :filename, :string    
    add_column :events, :thumbnail, :string 
    add_column :events, :size, :integer
    add_column :events, :width, :integer
    add_column :events, :height, :integer
  end

  def self.down
  end
end
