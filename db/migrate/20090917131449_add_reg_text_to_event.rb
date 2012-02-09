class AddRegTextToEvent < ActiveRecord::Migration
  def self.up
  	add_column :events, :registration_text, :text
  end

  def self.down
  end
end
