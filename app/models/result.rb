class Result < ActiveRecord::Base
	belongs_to :event
	belongs_to :rm_user
	
	attr_protected :rm_user_id, :event_id
	
	def pretty_pace
		res = ""
		unless pace_minute.blank?
			res += "#{pace_minute}m:"
		end
		unless pace_second.blank?
			res += "#{pace_second}s"
		end
	end
	
	def pretty_time
		res = ""
		unless hour.blank?
			res += "#{hour}h:"
		end
		unless minute.blank?
			res += "#{minute}m"
		end
		unless second.blank?
			res += ":#{second}s"
		end
	end
end
