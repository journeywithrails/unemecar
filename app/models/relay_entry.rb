class RelayEntry < ActiveRecord::Base
	belongs_to :relay_team
	validates_presence_of :first_name, :last_name, :date_of_birth, :email
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
	
	def validate
		errors.add_to_base "Emergency contact is required" if em_con_name.blank?
		errors.add_to_base "Emergency phone number is required" if em_con_phone.blank?
        #hack - remove certain validations for Melrose event
        unless self.relay_team.blank?
	        if self.relay_team.event_registration.race.event_type.discipline.name.upcase == "MULTISPORT"
	            errors.add_to_base "License number is required" if license_num.blank?
	            errors.add_to_base "Gender is required" if gender.blank?
	        end
			if (relay_team.event_registration.race.has_minimum_age)
				#first, validate the birthday by doing a date.parse
				#get age
				begin
					age = EventRegistration.race_age(date_of_birth, relay_team.event_registration.race.start_time)
		  			errors.add_to_base("You must be at least #{relay_team.event_registration.race.minimum_age} years old to register for this event.") unless age >= relay_team.event_registration.race.minimum_age
	  			rescue
	  				errors.add_to_base "you did not enter a valid date of birth"
	  			end
	  		end
  		end
	end
	
	def license_type
    	@fname
  	end
  	def license_type=(fname)
    	@fname = fname
  	end
end
