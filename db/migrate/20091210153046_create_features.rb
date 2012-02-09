class CreateFeatures < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
		t.column :image_file_name, :string
    	t.column :image_content_type, :string
    	t.column :image_file_size, :integer
    	t.column :image_updated_at, :datetime
    	t.column :feature_order, :integer
    	t.column :name, :string
    	t.column :link, :string
    	t.column :click_count, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :features
  end
end
