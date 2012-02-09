class EnhanceConInfo < ActiveRecord::Migration
  def self.up
  	add_column :contact_infos, :show_name, :boolean
  	add_column :contact_infos, :show_email, :boolean
  	add_column :contact_infos, :show_phone, :boolean
  	add_column :contact_infos, :show_address, :boolean
  end

  def self.down
  end
end
