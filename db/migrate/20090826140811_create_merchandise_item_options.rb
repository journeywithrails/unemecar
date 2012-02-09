class CreateMerchandiseItemOptions < ActiveRecord::Migration
  def self.up
    create_table :merchandise_item_options do |t|
		t.column :merchandise_item_id, :integer
		t.column :cost, :float
		t.column :order, :integer
		t.column :title, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :merchandise_item_options
  end
end
