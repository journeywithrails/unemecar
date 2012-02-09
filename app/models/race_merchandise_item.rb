class RaceMerchandiseItem < ActiveRecord::Base
  belongs_to :race
  belongs_to :merchandise_item
  
end