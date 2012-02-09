class CreateRaceFeeChanges < ActiveRecord::Migration
  def self.up
    create_table :race_fee_changes do |t|
    	t.column :fee, :float
    	t.column :race_id, :integer
    	t.column :change_date, :datetime
      t.timestamps
    end
    add_column :races, :initial_fee, :float
  end

  def self.down
    drop_table :race_fee_changes
  end
end
