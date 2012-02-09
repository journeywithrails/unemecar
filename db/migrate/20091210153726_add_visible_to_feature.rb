class AddVisibleToFeature < ActiveRecord::Migration
  def self.up
  	add_column :features, :visible, :boolean
  end

  def self.down
  end
end
