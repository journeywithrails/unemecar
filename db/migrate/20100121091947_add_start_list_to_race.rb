class AddStartListToRace < ActiveRecord::Migration
  def self.up
      add_column :races, :show_on_start_list, :boolean
  end

  def self.down
  end
end
