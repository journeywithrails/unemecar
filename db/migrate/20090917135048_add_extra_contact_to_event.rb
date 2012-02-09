class AddExtraContactToEvent < ActiveRecord::Migration
  def self.up
  	add_column :events, :contact_state, :string
  	add_column :events, :contact_city, :string
  	add_column :events, :contact_zip, :string
  	add_column :events, :contact_address, :string
  end

  def self.down
  end
end
