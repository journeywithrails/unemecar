class CapitalizeStates < ActiveRecord::Migration
  def self.up
  	Event.find(:all).each do | ev |
  		ev.state = ev.state.upcase
  		ev.save
  	end  	
  end

  def self.down
  end
end
