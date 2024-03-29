class CreateSeries < ActiveRecord::Migration
  def self.up
    create_table :series do |t|
    t.column :name, :integer    
    t.column :header, :string
    t.column :description, :text
    t.timestamps
    end
  end

  def self.down
    drop_table :series
  end
end
