class AddDiscTextToEvent < ActiveRecord::Migration
  def self.up
  	add_column :events, :disclaimer_text, :text
  end

  def self.down
  	remove_column :events, :disclaimer_text
  end
end
