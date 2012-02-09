class Coupon < ActiveRecord::Base
	belongs_to :event
	validates_presence_of :code, :value
end
