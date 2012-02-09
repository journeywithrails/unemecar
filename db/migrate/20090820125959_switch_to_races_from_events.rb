class SwitchToRacesFromEvents < ActiveRecord::Migration
  def self.up
  	Event.find(:all).each do | ev |
  		ev.event_types.each do | etype |
  			Race.create :event => ev, :event_type => etype
  		end
  	end
  end

  def self.down
  end
end
