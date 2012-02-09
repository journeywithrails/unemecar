class CreateHomeFeatures < ActiveRecord::Migration
  def self.up
   create_table :home_features do |t|
            t.column :image_file_name, :string
           t.column :image_content_type, :string
           t.column :image_file_size, :integer
           t.column :image_updated_at, :datetime
           t.column :feature_order, :integer
           t.column :name, :string
           t.column :link, :string
           t.column :click_count, :integer
            t.column :location, :string
            t.column :time, :datetime
            t.timestamps
          end
  end

  def self.down
    drop_table :home_features
  end
end
