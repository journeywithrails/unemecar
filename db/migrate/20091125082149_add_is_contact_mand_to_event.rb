class AddIsContactMandToEvent < ActiveRecord::Migration
  def self.up
  	add_column :events, :is_contact_mandatory, :boolean
  end

  def self.down
  end
end
