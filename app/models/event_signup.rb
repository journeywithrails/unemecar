class EventSignup < ActiveRecord::Base
	REG=0
	THINK=1
	ATT=2
	
	DATA_STR=["already registered for", "definitely attending", "considering attending"]
	
	belongs_to :rm_user
	belongs_to :event
end
