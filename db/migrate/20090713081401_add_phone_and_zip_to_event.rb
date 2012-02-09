class AddPhoneAndZipToEvent < ActiveRecord::Migration
  def self.up
  	add_column :events, :contact_phone, :string
  	add_column :events, :zip, :string
  end

  def self.down
  end
end
