class EventPayment < ActiveRecord::Base
	#used to record payments to race directors 
	belongs_to :event
end
