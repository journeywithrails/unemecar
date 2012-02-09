class TeamEntry < ActiveRecord::Base
    belongs_to :team
    belongs_to :event_registration
    accepts_nested_attributes_for :event_registration
    
    def name
    	"#{event_registration.first_name} #{event_registration.last_name}" unless event_registration.nil?
    end
end
