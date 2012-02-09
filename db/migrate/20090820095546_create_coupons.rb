class CreateCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |t|
    	t.column :event_id, :integer
    	t.column :code, :string
    	t.column :expiration, :datetime
    	t.column :value, :float
      t.timestamps
    end
  end

  def self.down
    drop_table :coupons
  end
end
