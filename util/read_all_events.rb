require 'csv'
require 'date'

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

CSV.open("../input/all_events.txt", 'r', "\t") do |row|

	#puts "\nreading #{row.inspect}"

	name = row[COL_NAME].to_s
	event_date = Date.parse(row[COL_DATE].to_s)
	city = row[COL_CITY].to_s
	state = row[COL_STATE].to_s
	start_time = row[COL_START_TIME].to_s
	address_info = row[COL_ADD_INFO].to_s
	description = row[COL_DESCRIPTION].to_s
	register_link = row[COL_WEBSITE].to_s
	contact_name = row[COL_CONTACT_INFO].to_s
	contact_email = row[COL_CONTACT_EMAIL].to_s
	map_link = row[COL_MAP_LINK].to_s
	discipline = row[COL_DISCIPLINE].to_s

  # cleanup
	name = name.lstrip
	city = city.lstrip

	ev_type_name = row[COL_EV_TYPE_1].to_s
	ev_type_name_2 = row[COL_EV_TYPE_1_2].to_s
	ev_type_name_3 = row[COL_EV_TYPE_1_3].to_s
	ev_type_name_4 = row[COL_EV_TYPE_1_4].to_s
	
	if discipline.nil? or discipline=="Other" or discipline=="other" then
	  puts " > discipline [#{discipline}], #{event_date} --- #{name}"
  end
	
end