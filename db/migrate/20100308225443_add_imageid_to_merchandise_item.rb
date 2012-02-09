class AddImageidToMerchandiseItem < ActiveRecord::Migration
  def self.up
    add_column :merchandise_items, :image_id, :integer
    rename_column :images, :content_type, :file_content_type
    rename_column :images, :filename, :file_file_name
    rename_column :images, :size, :file_file_size
    add_column :images, :file_updated_at, :datetime
  end

  def self.down
    remove_column :merchandise_items, :image_id
    rename_column :images, :file_content_type, :content_type
    rename_column :images, :file_file_name, :filename
    rename_column :images, :file_file_size, :size
    remove_column :images, :file_updated_at
  end
end
