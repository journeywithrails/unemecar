class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
		t.column :content_type, :string
      t.column :filename, :string    
      t.column :thumbnail, :string 
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
      t.timestamps
    end
    #delete the columns from event
    
    #remove_column :events, :filename   
    remove_column :events, :thumbnail
    remove_column :events, :size
    remove_column :events, :width
    remove_column :events, :height
  end

  def self.down
    drop_table :images
  end
end
