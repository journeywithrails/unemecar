class ReassignOthers < ActiveRecord::Migration
  
  # assign the event type to the event
  def self.set(date_string, event_name, discipline, event_type_name)
    date = DateTime.parse(date_string)
    event = Event.find(:first, :conditions => {:name => event_name, :event_date => date.to_s})
    event_type = EventType.find(:first, :conditions => {:name => event_type_name, :discipline_id => discipline.id})
    raise "event is nil! #{date_string} #{event_name}" if (event.nil?)
    raise "event_type is nil! #{event_type_name}" if (event_type.nil?)
    event.event_types << event_type if !event.event_types.include?(event_type)
  end

  # remove
  def self.rem(date_string, event_name)
    date = DateTime.parse(date_string)
    event = Event.find(:first, :conditions => {:name => event_name, :event_date => date.to_s})
    if (event.nil?)
      puts "[warning] event is nil! #{date_string} #{event_name}" 
    else
      Event.destroy(event.id)
    end
  end

  def self.up

    running = Discipline.find_by_name("Running")
    cycling = Discipline.find_by_name("Cycling")
    multisport = Discipline.find_by_name("Multisport")

    set("2009-05-11", "Four Miles For Smiles", running, "other")
    set("2009-11-29", "12th Annual Turkey Lane Turkey Trot", running, "other")
    set("2009-07-05", "Howell Independence Aquathlon", multisport, "aquathlon")
    set("2009-07-26", "Mackinaw Multi-Sport Mix", multisport, "other")
    set("2009-10-17", "Grubers Grinder", cycling, "mtb: cross-country")
    set("2009-07-18", "Urban Dare Denver", multisport, "adventure race")
    set("2009-06-21", "Mountains to Sound Relay", multisport, "other")
    rem("2009-06-28", "The Ridges Invitational 5k Open Water Swim")
    set("2009-05-30", "Fresno Splash and Dash", multisport, "other")
    set("2009-05-30", "Fresno Splash and Dash", multisport, "other")
    set("2009-06-07", "Ventura Splash N Dash 2", multisport, "other")
    set("2009-06-07", "Ventura Splash N Dash 2", multisport, "other")
    set("2009-06-07", "Playa del Run Beach Festival - Huntington Beach", multisport, "other")
    set("2009-05-31", "Y-Tri Sprint Triathlon and Aquabike", multisport, "other")
    set("2009-06-07", "Pirate Tri", multisport, "other")
    set("2009-07-05", "Oxnard Splash N Dash", multisport, "other")
    set("2009-07-05", "Oxnard Splash N Dash", multisport, "other")
    set("2009-07-11", "Ventura Splash N Dash Series #3", multisport, "other")
    set("2009-07-11", "Ventura Splash N Dash Series #3", multisport, "other")
    set("2009-07-12", "Alcatraz Challenge Aquathlon & Swim", multisport, "aquathlon")
    set("2009-07-12", "Alcatraz Challenge Aquathlon & Swim", multisport, "aquathlon")
    set("2009-07-19", "Playa del Run Beach Festival - Playa del Rey", multisport, "other")
    rem("2009-07-25", "Lake Del Val Du")
    set("2009-08-16", "Playa del Run Aquathlon 	", multisport, "aquathlon")
    set("2009-08-17", "Oxnard Splash N Dash", multisport, "other")
    set("2009-08-17", "Oxnard Splash N Dash", multisport, "other")
    set("2009-08-30", "Ventura Splash N Dash (short) ", multisport, "other")
    set("2009-08-30", "Ventura Splash N Dash Aquathlon #4 	", multisport, "aquathlon")
    set("2009-09-20", "Playa del Run Aquathlon ", multisport, "aquathlon")
    #set("2009-09-26", "Central Valley Super Sprint Triathlon ", multisport, "tri: sprint")
    set("2009-10-11", "Ventura Splash N Dash (short) ", multisport, "other")
    set("2009-10-11", "Ventura Splash N Dash ", multisport, "other")
    set("2009-06-07", "Keuka Lake Aquabike ", multisport, "tri: sprint")
    set("2009-06-07", "Keuka Lake Aquabike ", multisport, "other")
    set("2009-07-01", "Wantagh Park Aquathlon #1 ", multisport, "aquathlon")
    set("2009-07-15", "Wantagh Park Aquathlon #2 ", multisport, "aquathlon")
    set("2009-07-15", "Wantagh Park Aquathlon #2 ", multisport, "aquathlon")
    set("2009-07-18", "Stars & Stripes Aquathlon ", multisport, "aquathlon")
    set("2009-07-29", "Wantagh Park Aquathlon #3 ", multisport, "aquathlon")
    set("2009-08-12", "Wantagh Park Aquathlon #4 ", multisport, "aquathlon")
    set("2009-08-26", "Wantagh Park Aquathlon #5 ", multisport, "aquathlon")
    rem("2009-05-29", "Great Hudson River Swim ")
    rem("2009-06-06", "Manhattan Island Marathon Swim ")
    rem("2009-06-14", "Park to Park Swim")
    rem("2009-06-26", "Liberty Island Swim ")
    rem("2009-07-18", "Riverside Park 1.5K Swim ")
    rem("2009-09-04", "Governors Island Swim ")
    rem("2009-09-12", "Brooklyn Bridge 1K Swim ")
    rem("2009-09-26", "Little Red Lighthouse Swim ")
    rem("2009-10-17", "Ederle Swim ")
    #set("2009-06-10", "Splash and Dash at Kings Grant ", multisport, "other")
    #set("2009-07-08", "Marlton Lakes Splash and Dash ", multisport, "other")
    #set("2009-08-02", "2nd Annual Aquathlon Challenge 2009 (Off Road)", multisport, "aquathlon")
    set("2009-01-17", "One Day Extreme", multisport, "adventure race")
    set("2009-05-23", "Wild Wonderful 24hr Adventure Race", multisport, "adventure race")
    rem("2009-05-31", "Rehab To Racing Open Water Swim Training Venue")
    set("2009-06-12", "Equinox Traverse Expedition Adventure Race", multisport, "adventure race")
    rem("2009-07-11", "Chris Greene Lake 1- & 2-Mile Swim")
    rem("2009-07-12", "Rehab To Racing Open Water Swim Training Venue")
    set("2009-07-25", "One Day Adventure Race", multisport, "adventure race")
    set("2009-09-12", "Little-Big Adventure", multisport, "other")
    set("2009-06-20", "Lovelands Amazing Race", multisport, "other")
    set("2009-07-11", "Headwaters Adventure Race", multisport, "adventure race")
    rem("2009-02-22", "Fresh Tracks 5K Snowshoe Race")
    
    # there are two entries, and both are a bit corrupt
    rem("2009-05-09", "Lake Wobegon Trail Marathon")
    rem("2009-05-09", "Lake Wobegon Trail Marathon")
    
    #raise "not done yet!"
  end

  def self.down
  end
end
