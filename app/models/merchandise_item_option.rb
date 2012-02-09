class MerchandiseItemOption < ActiveRecord::Base
	belongs_to :merchandise_item
  attr_accessor :mopid
  has_many :merchandise_orders
  
end
