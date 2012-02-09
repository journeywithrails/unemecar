class CleanUpEventAttrs < ActiveRecord::Migration
  def self.up
  	#get all events and remove leading spaces from race name and race city
  #	Event.find(:all).each do | ev |
  #		ev.name = ev.name.lstrip
  #		ev.city = ev.city.lstrip
  #		ev.save
  #	end  	
  	  	
  	
  end

  def self.down
  end
end
