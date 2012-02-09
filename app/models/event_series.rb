class EventSeries < ActiveRecord::Base
	has_many :events
	
	def self.create_from_events(name, ids)
	  ser = EventSeries.create :name => name
	  ids.each do |id|
	    ev = Event.find(id)
	    ser.events << ev
	  end
	  ser
	 
	end
end
