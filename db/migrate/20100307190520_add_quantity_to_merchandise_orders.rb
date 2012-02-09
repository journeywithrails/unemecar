class AddQuantityToMerchandiseOrders < ActiveRecord::Migration
  def self.up
    add_column :merchandise_orders, :quantity, :integer, :default => 0
     
  end

  def self.down
    remove_column :merchandise_orders, :quantity
  end
end
