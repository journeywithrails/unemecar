class CreateRaceMerchJoinTable < ActiveRecord::Migration
  def self.up
    create_table :race_merchandise_items, :force => true do |t|
      t.integer :race_id
      t.integer :merchandise_item_id
    end
  end

  def self.down
    drop_table :race_merchandise_items
  end
  
end
