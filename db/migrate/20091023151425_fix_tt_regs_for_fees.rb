class FixTtRegsForFees < ActiveRecord::Migration
  def self.up
  	begin
	  	ev = Event.find(4621)
	  	unless ev.nil?
	  		ev.races.each do | race |
	  			race.event_registrations.find_all_by_processed(true).each do | ereg |
	  				if ereg.cost.blank? or ereg.cost == 0
	  					service_fee = EventRegistration.calculate_service_fee(race.current_fee(ereg.created_at))
						total_cost = race.current_fee(ereg.created_at).to_f + service_fee.to_f
						ereg.service_fee = service_fee
						ereg.cost = race.current_fee(ereg.created_at)
						ereg.save 
	  				end
	  			end
	  		end
	  	end
  	rescue
  		
  	end
  end

  def self.down
  end
end
