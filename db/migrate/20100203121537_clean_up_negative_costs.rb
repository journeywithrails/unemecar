class CleanUpNegativeCosts < ActiveRecord::Migration
  def self.up
      # find all registrations with negative costs, and fix them
      EventRegistration.find(:all, :conditions => ["processed = true and cost < 0"]).each do |reg|
          print "cleaning reg ID='#{reg.id}'\n"
          if reg.cost < 0
              reg.cost = 0
              reg.save
          end
      end
  end

  def self.down
  end
end
