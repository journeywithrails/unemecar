class RelayTeam < ActiveRecord::Base
	belongs_to :event_registration
	has_many :relay_entries
	
	validates_presence_of :name
	accepts_nested_attributes_for :relay_entries
end
