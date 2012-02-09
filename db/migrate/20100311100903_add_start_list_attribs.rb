class AddStartListAttribs < ActiveRecord::Migration
  def self.up
  	add_column :events, :show_total_on_start_list, :boolean
  end

  def self.down
  end
end
