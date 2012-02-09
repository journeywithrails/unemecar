class AddCouponForReg < ActiveRecord::Migration
  def self.up
  	#supporting only one coupon per registration
  	add_column :event_registrations, :coupon_id, :int
  end

  def self.down
  end
end
