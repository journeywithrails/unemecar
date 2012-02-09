class PersonalBest < ActiveRecord::Base
	belongs_to :event_type
	belongs_to :rm_user
	belongs_to :result
end
