class MerchandiseItem < ActiveRecord::Base
	belongs_to :event
	has_many :merchandise_item_options, :dependent => :destroy
	accepts_nested_attributes_for :merchandise_item_options, :allow_destroy => true
	belongs_to :image, :dependent => :destroy
	accepts_nested_attributes_for :image, :allow_destroy => true
	
	has_many :race_merchandise_items
	has_many :races, :through => :race_merchandise_items

	attr_accessor :races_ids

	after_create :add_races
	after_update :add_races
	
	
	def add_races
	  new_mraces = RaceMerchandiseItem.find_all_by_race_id(self.races_ids)
	  all_mraces = new_mraces | self.race_merchandise_items
	  (all_mraces - new_mraces).each do |mrace|
	    mrace.destroy
	  end 
	  
	  new_races = Race.find(self.races_ids)
	  new_races.each do |race| 
	    self.races << race unless self.races.include?(race)
	  end 
	  
	end
	
end
