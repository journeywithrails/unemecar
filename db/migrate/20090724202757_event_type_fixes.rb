class EventTypeFixes < ActiveRecord::Migration
  def self.up
    
    events = Event.find(:all)

    duathlon_event_type = EventType.find_by_name('duathlon')
    duathlon_discipline = Discipline.find_by_name('Duathlon')
    other_discipline = Discipline.find_by_name('Other')
    multisport_discipline = Discipline.find_by_name('Multisport')

    # convert events classified as sport "duathlon" to be sport "multisport" and event type "duathlon"
    puts "converting events from discipline 'Duathlon' to discipline 'Multisport', event type 'duathlon'"
    count = 0
    events.each do |event|
      if (event.discipline == duathlon_discipline) or (!event.event_type.nil? and event.event_type.discipline == duathlon_discipline)
        #puts "  changing #{event.name} from #{event.discipline}"
        event.discipline = multisport_discipline
        event.event_types << duathlon_event_type if !event.event_types.include?(duathlon_event_type)
        #puts "  changed #{event.name} to #{event.discipline}"
        event.save!
        count+=1
      end
    end
    puts "  changed #{count} events from discipline 'Duathlon' to discipline 'Multisport', event type 'duathlon'"
    
    # check to make sure no events are sport Duathlon or Other - before we delete those disciplines
    puts "making sure no events are sport 'Duathlon'"
    events.each do |event|
      if event.discipline == duathlon_discipline 
        raise "[Error] event discipline is still 'Duathlon' for '#{event.name}' on #{event.event_date}"
      end
      #if event.discipline == other_discipline 
      #  raise "[Error] event discipline is 'Other' for '#{event.name}' on #{event.event_date}"
      #end
    end
    
    #raise "not done yet"
    
    # remove sports "duathlon" (change events that have these to have something else)
    puts "removing sport 'Duathlon'"
    #duathlon_discipline.delete() if !duathlon_discipline.nil?
    Discipline.destroy(duathlon_discipline.id)
    #other_discipline.delete()
    puts "  deleted duathlon discipline"
    
    # new multisport events
    puts "adding new multisport events"
    list = ["tri: sprint", "tri: olympic/int'l", "tri: half-ironman", "tri: ironman", "duathlon", "aquathlon", "other", "swimming"]
    list.each do |name|
      if EventType.find_by_name(name).nil?
        et = EventType.new()
        et.name = name
        et.discipline = multisport_discipline
        et.save!
        puts "  added new multisport event #{name}"
      end
    end
      
    # new running events
    puts "adding new running events"
    list = ["other"]
    list.each do |name|
      if EventType.find_by_name(name).nil?
        et = EventType.new()
        et.name = name
        et.discipline = Discipline.find_by_name("Running")
        et.save!
        puts "added new running event #{name}"
      end
    end
    
    # add cycling events
    puts "adding new cycling events"
    list = ["cyclocross", "mtb: cross-country", "mtb: downhill", "mtb: super d", "mtb: dual slalom", "mtb: short track", "mtb: trials"]
    list.each do |name|
      if EventType.find_by_name(name).nil?
        et = EventType.new()
        et.name = name
        et.discipline = Discipline.find_by_name("Cycling")
        et.save!
        puts "added new cycling event #{name}"
      end
    end
  
    # fix urls... underscore before http...
    puts "fixing register links"  
    count = 0
    events.each do |event|
      if !event.register_link.nil?
        event.register_link = event.register_link.lstrip 
        event.register_link.sub!("http://hhtp//", "http://")
        event.register_link.sub!("http://hhttp//", "http://")
        event.register_link.sub!("http://htpp//", "http://")
      end
      #puts "#{event.register_link}" if !event.register_link.nil? and event.register_link.size>0
      event.save!
    end

    #raise "not done yet!"

  end

  def self.down
  end
  
end