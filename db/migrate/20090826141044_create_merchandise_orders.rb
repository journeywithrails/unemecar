class CreateMerchandiseOrders < ActiveRecord::Migration
  def self.up
    create_table :merchandise_orders do |t|
		t.column :merchandise_item_option_id, :integer
		t.column :event_registration_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :merchandise_orders
  end
end
