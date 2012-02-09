require 'csv'

require File.join(File.dirname(__FILE__), '../config/environment.rb')

def go()

  other_other = EventType.find_by_id(18)

  # load events from tab-delimited text file
  puts "loading events from file..."
  csv_events_hash = load_events_from_tab_delimited_file("../input/all_events.txt")

  # load all events in db
  puts "loading events from db..."
  db_events = Event.find(:all)

  # update each db event with the multiple events in the txt file
  puts "updating event types in events..."
  db_events.each do |db_event|

    key = hash_code(db_event)
    csv_event = csv_events_hash[key]

    # remove event type "other" for discipline "Other"
    if db_event.event_types.include?(other_other)
      puts "#{db_event.dn} ... remove event type '#{other_other.discipline_id}:#{other_other.name}'"
      #db_event.event_types.delete(other_other)
    end

    if csv_event.nil?
      puts "[Warning] no csv_event for db_event #{db_event.event_date} -- #{db_event.name}"
    else

      # make sure the db_event has the event types
      csv_event.event_types.each do |et|
        if !db_event.event_types.include?(et)
          puts "#{db_event.dn} ... add event type '#{other_other.discipline_id}:#{et.name}'"
          #db_event.event_types << et
        end
      end
  
    end
  end
  
  raise "not done yet!"
end

def self.hash_code(event)
  key = "#{event.name}_#{event.event_date.strftime("%m/%d/%Y")}"
  return key
end

# columns
COL_NAME=2
COL_DATE=1
COL_CITY=3
COL_STATE=4
COL_START_TIME=5
COL_ADD_INFO=6
COL_DESCRIPTION=7
COL_WEBSITE=8
COL_CONTACT_INFO=9
COL_CONTACT_EMAIL=10
COL_MAP_LINK=11
COL_DISCIPLINE=14
COL_EV_TYPE_1=15
COL_EV_TYPE_1_2=16
COL_EV_TYPE_1_3=17
COL_EV_TYPE_1_4=18

# adjusts the extra event types, without adjusting the discipline
def self.fix(ev_type_name)
  cindex = ev_type_name.index(" (")
	if cindex.nil? == false
		cand = ev_type_name[0, cindex]
		#special code for marathons, and tris
		if cand == "sprint" #dis: mutlisport, et: sprint
			#ev.discipline = Discipline.find_by_name("Multisport")
		elsif cand == "13.1"
			#ev.discipline = Discipline.find_by_name("Running")
			cand = "half marathon"
		elsif cand == "26.2"
			#ev.discipline = Discipline.find_by_name("Running")
			cand = "marathon"
		elsif cand == "half-ironman"
			#ev.discipline = Discipline.find_by_name("Multisport")
			cand = "half ironman"
		end
		ev_type_name = cand
	else
		#check for duathlon and aquathon
		if ev_type_name == "aquathon" or ev_type_name == "aquathlon"
			#ev.discipline = Discipline.find_by_name("Multisport")
			ev_type_name = "aquathlon"
		elsif ev_type_name == "duathlon"
			#ev.discipline = Discipline.find_by_name("Multisport")
		end
	end
	return ev_type_name
end

def self.load_events_from_tab_delimited_file(csv_data)

  res_events = Hash.new
  #CSV.open(csv_data, 'r') do |row|
  CSV.open(csv_data, 'r', "\t") do |row|

  	#puts 'importing ' + row[COL_NAME].to_s + '\n'

		ev = Event.new
		ev.name = row[COL_NAME].to_s
		#parse date
		ev.event_date = Date.parse(row[COL_DATE].to_s)
		ev.city = row[COL_CITY].to_s
		ev.state = row[COL_STATE].to_s
		ev.start_time = row[COL_START_TIME].to_s
		ev.address_info = row[COL_ADD_INFO].to_s
		ev.description = row[COL_DESCRIPTION].to_s
		ev.register_link = row[COL_WEBSITE].to_s
		ev.contact_name = row[COL_CONTACT_INFO].to_s
		ev.contact_email = row[COL_CONTACT_EMAIL].to_s
		ev.map_link = row[COL_MAP_LINK].to_s
		
		discipline_name = row[COL_DISCIPLINE].to_s.capitalize
		
		# translate discipline names
		if discipline_name=="Triathlon" then discipline_name = "Multisport" end
  	if discipline_name=="Duathlon" then discipline_name = "Multisport" end
		
		discipline = Discipline.find_by_name(discipline_name)

	  # cleanup
		ev.name = ev.name.lstrip
		ev.city = ev.city.lstrip

		ev_type_name = row[COL_EV_TYPE_1].to_s
		ev_type_name_2 = row[COL_EV_TYPE_1_2].to_s
		ev_type_name_3 = row[COL_EV_TYPE_1_3].to_s
		ev_type_name_4 = row[COL_EV_TYPE_1_4].to_s

		ev_type_name_2 = fix(ev_type_name_2)
		ev_type_name_3 = fix(ev_type_name_3)
		ev_type_name_4 = fix(ev_type_name_4)

		#ev.event_type = EventType.find_by_name(ev_type_name)

    if discipline.nil? 
      puts "nil discipline '#{row[COL_DISCIPLINE].to_s.capitalize}'"
    else
  		type1 = EventType.find(:first, :conditions => { :name => ev_type_name, :discipline_id => discipline.id } )
  		type2 = EventType.find(:first, :conditions => { :name => ev_type_name_2, :discipline_id => discipline.id } )
  		type3 = EventType.find(:first, :conditions => { :name => ev_type_name_3, :discipline_id => discipline.id } )
  		type4 = EventType.find(:first, :conditions => { :name => ev_type_name_4, :discipline_id => discipline.id } )
    end

		ev.event_types << type1 if !type1.nil?
		ev.event_types << type2 if !type2.nil?
		ev.event_types << type3 if !type3.nil?
		ev.event_types << type4 if !type4.nil?

	  #puts "#{ev.name}, #{ev.event_types.size} event types"
	  #puts "  event_types #{ev.event_types.size}" if ev.event_types.size>1

  	#store it in the hash
  	key = hash_code(ev)
  	#puts "  key #{key}"
  	res_events[key] = ev
  	
  end

  return res_events
end

go()