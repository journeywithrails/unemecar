class AddRaceName < ActiveRecord::Migration
  def self.up
  	add_column :races, :name, :string
  end

  def self.down
  end
end
