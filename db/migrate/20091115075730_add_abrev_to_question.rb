class AddAbrevToQuestion < ActiveRecord::Migration
  def self.up
  	add_column :questions, :abbreviation, :string
  end

  def self.down
  end
end
