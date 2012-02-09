class CreateDiscounts < ActiveRecord::Migration
  def self.up
    create_table :discounts do |t|
		t.column :event_id, :integer
		t.column :race_group_id, :integer
		t.column :is_deduct, :boolean
		t.column :value, :float
      t.timestamps
    end
  end

  def self.down
    drop_table :discounts
  end
end
