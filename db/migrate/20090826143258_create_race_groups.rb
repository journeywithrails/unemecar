class CreateRaceGroups < ActiveRecord::Migration
  def self.up
    create_table :race_groups do |t|
		t.column :event_id, :integer
		t.column :title, :string
		t.column :group_order, :integer
		t.column :is_default, :boolean
      t.timestamps
      
    end
    
    #add support in the races table
      add_column :races, :race_group_id, :integer
      add_column :races, :race_group_order, :integer
      
  end

  def self.down
    drop_table :race_groups
  end
end
