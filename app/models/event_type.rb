class EventType < ActiveRecord::Base
	#has_many :events
	has_and_belongs_to_many :events
  	belongs_to :discipline
  	
  	def is_tri_event
  		
  	end
  	
  	def name_with_discipline
  		"#{discipline.name} - #{name}"
  	end
end