class RemoveOtherDisciplineEventType < ActiveRecord::Migration
  def self.up
    et = EventType.find(:first, :conditions => {:name => "other", :discipline_id => 5})
    puts "et is #{et.inspect}"
    EventType.destroy(et)
  end

  def self.down
  end
end
