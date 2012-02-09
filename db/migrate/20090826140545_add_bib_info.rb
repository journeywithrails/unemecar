class AddBibInfo < ActiveRecord::Migration
  def self.up
  	add_column :event_registrations, :bib_number, :string
  end

  def self.down
  end
end
