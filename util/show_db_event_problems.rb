require 'csv'

require File.join(File.dirname(__FILE__), '../config/environment.rb')

def hash_code(event)
  key = "#{event.name}_#{event.event_date.strftime("%m/%d/%Y")}"
  return key
end


db_events = Event.find(:all)

num_events_with_problems = 0
num_problems = 0

other_discipline = Discipline.find_by_name('Other')

hash = Hash.new

db_events.each do |db_event|
  
  bad_other = EventType.find(:first, :conditions => {:name => 'other', :discipline_id => 18})

  s = ""
  
  # check if event is no event types
  if db_event.event_types.size==0 then s += "\n  > event_types is empty!"; num_problems+=1; end

  # check if event has bad other
  if db_event.event_types.include?(bad_other) then s += "\n  > event has bad other!"; num_problems+=1; end

  # collect duplicates
  key = hash_code(db_event)
  if !hash.has_key?(key) then hash[key] = Array.new end
  hash[key] << db_event

  if s.length>0 then
    s = "#{db_event.event_date.strftime("%m/%d/%Y")} --- #{db_event.name} --- #{db_event.register_link}#{s}"
    puts s
    num_events_with_problems+=1
  end
  
end

# check for duplicate events
hash.values.each do |list|
  
  if (list.size>1)
    list.each do |ev|
      puts "##{ev.id} - #{ev.dn}"
    end
  end
  
end

puts "\n  #{num_problems} problems"
puts "  #{num_events_with_problems} events with problems"
puts