module RegisterHelper
	
	def tri_disclaimer
		
	end
	
	def optional_tag(event)
		"(optional)" unless event.is_contact_mandatory
	end
	
	def is_relay_flow
		 
	end
	
	def answer_questions_title(race)
	  "Please Answer Faqs"
	end
	
	def athlete_info_title(race)
		if race.supports_team_creation
			"Team Information"
		else
			"Athlete Information"
		end
	end
	
	def first_name_title(race)
		if race.supports_team_creation
			"Captain First Name"
		else
			"First Name"
		end
	end
	
	def last_name_title(race)
		if race.supports_team_creation
			"Captain Last Name"
		else
			"Last Name"
		end
	end
end
