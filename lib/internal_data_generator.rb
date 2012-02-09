class InternalDataGenerator
	 require 'fastercsv'
  RACE_STR = ["5k open", "8k invitational", "Masters series", "Kids 10k", "Men Marathon"]
	RACE_IDS = [1,2,3,4,5]
	RACE_PRIZES = [1000,2500,1500,4000,3000]
	RACE_FEES = [10,25,15,40,30]
	
	
	#helper method to generate data so the system could be tested better
	def self.generate_dummy_event(name)
		start_date = DateTime.new(2009, 11, 20, 12, 0, 0)
		end_date = DateTime.new(2009, 11, 20, 18, 0, 0)
		event = Event.create :name => name, :event_date => start_date, :end_time => end_date, :host => "The Running co", :tag_line => "The best race in town"
		#additional event fields
		event.description = "The best race in Boston in Nov 20th. Come check it out!!"
		event.presented_by = "Nike"
		event.benefiting = "Lance Armstrong"
		event.register_link = "http://www.bestraceintown.com"
		event.address_info = "2 Beacon st"
		event.city = "Boston"
		event.state = "MA"
		event.zip = "02111"
		event.is_register_open = true
		#add banner to event
				
		event.save
		#create a few races, put them all in the default group
		5.times do | i |
			r = Race.new
			r.race_group = event.race_groups.first
			r.race_group_order = i
			r.name = RACE_STR[i]
			r.event_type_id = RACE_IDS[i]
			r.prizes = RACE_PRIZES[i]
			r.initial_fee = RACE_FEES[i]
			r.start_time = DateTime.new(2009, 10, 20, 12 + i, 0, 0)
			r.event = event
			r.distance = 10
			r.distance_unit = 0
			r.save
			event.event_types << (EventType.find(RACE_IDS[i]))
		end
		
		#create merchandise
		m1 = MerchandiseItem.create :is_donation => true, :title => "donation to Eyal's Foundation", :description => "This is a donation for Eyal's foundation", :event => event
		
		m2 = MerchandiseItem.create :is_donation => false, :title => "Race Hat", :description => "Cool looking Hat", :event => event
		m2.merchandise_item_options << (MerchandiseItemOption.create :o_order => 1, :title => "S - small", :cost => 20.00)
		m2.merchandise_item_options << (MerchandiseItemOption.create :o_order => 2, :title => "M - medium", :cost => 20.00) 
		
		#add images to merchandise
		
		#create custom questions
		q1 = Question.create :event => event, :title => "how did you hear about this race", :question_type => Question::DROPDOWN_LIST, :q_order => 1, :is_required => true
		q1.question_options << (QuestionOption.create :q_order => 1, :title => "Internet")
		q1.question_options << (QuestionOption.create :q_order => 2, :title => "Billboard")
		q1.question_options << (QuestionOption.create :q_order => 3, :title => "From a friend")
		
		#create coupons
		Coupon.create :event => event, :code => "EKE123", :value => 10.00, :expiration => DateTime.new(2009, 10, 18, 18, 0, 0)
		Coupon.create :event => event, :code => "ERLYBRD", :value => 5.00, :expiration => DateTime.new(2009, 10, 14, 18, 0, 0)
		#TODO create fee changes
		
		event
	end
	
	def self.create_ev_and_reg(name)
		ev = generate_dummy_event(name)
		data = [1560,1645,1889,2345,2466,2566]
		
		#go through each event ID and see if the user has an event reg for that event. if not, create one.
		data.each do |us_id|
			
			cand = nil#ev.event_registrations.find_by_user_id(us_id)
			if cand.nil? and (ev.nil? == false )
				#create an event registration
				erg = EventRegistration.new
				erg.email = "ekedem@gwiz.com" + " #{us_id}" 
				erg.phone = "61616555" + " #{us_id}" 
				erg.address = "9 Columbia street" + " #{us_id}" 
				erg.apt = "8" + " #{us_id}" 
				erg.city = "Brookline" + " #{us_id}" 
				erg.state = "MA"
				erg.zip = "02446" + " #{us_id}" 
				erg.em_con_name = "George Costanze" + " #{us_id}" 
				erg.em_con_phone = "46464646" + " #{us_id}" 
				erg.em_con_relationship = "Parent" + " #{us_id}" 
				erg.sex = "Male" + " #{us_id}" 
				erg.first_name = "Eyal" + " #{us_id}" 
				erg.last_name = "Kedem" + " #{us_id}" 
				erg.event_id = ev.id
				erg.rm_user_id = us_id
				race = ev.races[rand(ev.races.size)]
				erg.race = race
				service_fee = EventRegistration.calculate_service_fee(race.current_fee)
				total_cost = race.current_fee.to_f + service_fee.to_f
				erg.service_fee = service_fee
				erg.cost = race.current_fee
				erg.processed = true
				erg.save
				
			end
		end
		ev		
	end
	
	
	def self.generate_dummy_regs(user_id)
		data = [1225,1519,1629]
		usr = RmUser.find(user_id)
		#go through each event ID and see if the user has an event reg for that event. if not, create one.
		data.each do |evtid|
			ev = Event.find(evtid)
			cand = usr.event_registrations.find_by_event_id(evtid)
			if cand.nil? == false
				cand.delete
			end
			if ev.nil? == false
				#create an event registration
				erg = EventRegistration.new
				erg.email = "ekedem@gwiz.com" + " #{evtid}" 
				erg.phone = "61616555" + " #{evtid}" 
				erg.address = "9 Columbia street" + " #{evtid}" 
				erg.apt = "8" + " #{evtid}" 
				erg.city = "Brookline" + " #{evtid}" 
				erg.state = "MA"
				erg.zip = "02446" + " #{evtid}" 
				erg.em_con_name = "George Costanze" + " #{evtid}" 
				erg.em_con_phone = "46464646" + " #{evtid}" 
				erg.em_con_relationship = "Parent" + " #{evtid}" 
				erg.sex = "Male" + " #{evtid}" 
				erg.first_name = "Eyal" + " #{evtid}" 
				erg.last_name = "Kedem" + " #{evtid}" 
				erg.event_id = evtid
				erg.rm_user_id = usr.id
				erg.processed = true
				erg.save
				
				#create an event signup as well
				add_to_mrm = EventSignup.new
			    add_to_mrm.event_id = evtid
			    add_to_mrm.rm_user_id = user_id
			    add_to_mrm.reg_type = EventSignup::ATT
			    add_to_mrm.save
				
			end
		end		
	end
	
	def self.clean_up_comm_tri
		#for these 3 events, look for regs that dont have the event id set up, and set it from the race
  		data = [5238,5239,5226]
  		data.each do |evtid|
  			ev = Event.find(evtid)
  			ev.races.each do | race |
  				regs = race.event_registrations.find(:all, :conditions => ["processed = true AND event_id != #{evtid}"])
  				print "about to process #{regs.size} bad entries for '#{race.name}' in '#{ev.name}'\n"
  				
  				regs.each do | reg|
  					reg.payment_notes = "moved from #{reg.event_id} to #{reg.race.event.id}"
  					reg.event_id = reg.race.event.id
  					reg.save
  				end
  			end
  		end
	end
	
	def self.clean_up_comm_tri_mrm
		#for events that were moved (see clean_up_comm_tri), we need to synch the MRM data. right now, they have MAR tri. we need to create the correct MRM entry for them.
		EventRegistration.find(:all, :conditions => ["processed = true AND payment_notes LIKE ?", "moved from%"]).each do | reg |
			tokens = reg.payment_notes.split(' ')
			bad_e = tokens[2].to_i
			good_e = tokens[4].to_i
			#get the user
			user = reg.rm_user
			#see if they have an entry to the bad event
			bad_es = EventSignup.find_by_event_id_and_rm_user_id(bad_e, user.id)
			#if so, check if they have a valid reg for the bad event. if not, delete the bad event signup
			unless bad_es.nil?
				bad_reg = user.event_registrations.find_by_processed_and_event_id(true, bad_e)
				unless bad_reg.nil? == false
					bad_es.delete
					print "DELETING a reg for user #{user.id} (#{reg.first_name}, #{reg.last_name}) FROM event #{bad_e}\n"
				end	
			end
			#see if they have a signup for the good event
			good_es = EventSignup.find_by_event_id_and_rm_user_id(good_e, user.id)
			#if not, create one
			unless good_es.nil? == false
				add_to_mrm = EventSignup.new
	      		add_to_mrm.event_id = good_e
	      		add_to_mrm.rm_user_id = user.id
	      		add_to_mrm.save
	      		print "CREATING a reg for user #{user.id} (#{reg.first_name}, #{reg.last_name}) TO event #{good_e}\n"
			end
		end
		true
		
	end
	
	#look for reg duplicates in a given event. logic looks for entries with the same first and last name, that are in the same race
	def self.event_reg_duplicates(event_id)
		Event.find(event_id).races.each do | race |
			
			#Hash of key and array
			race_reg_hash = Hash.new
			race.procssed_registrations.each do |reg|
				key = "#{reg.first_name}-#{reg.last_name}"
				if race_reg_hash.has_key?("#{reg.first_name}-#{reg.last_name}")
    				array = race_reg_hash["#{reg.first_name}-#{reg.last_name}"]
    				array << reg
    				race_reg_hash["#{reg.first_name}-#{reg.last_name}"] = array
    			else
    				array = Array.new
    				array << reg
    				race_reg_hash["#{reg.first_name}-#{reg.last_name}"] = array
    			end
			end
			#print duplicates info
			print "processing #{race.name}\n"
			race_reg_hash.values.each do | arr| 
				if arr.size > 1
					reg = arr[0]
					print "#{reg.first_name}, #{reg.last_name}, #{arr.size}\n"
				end
			end
		end
		true
	end

  def self.export_event_data

      FasterCSV.open("#{RAILS_ROOT}/export.csv", "w") do |csv|
        arr = ["Email","Name","Phone","Event Name","Event Location","Event Description","Event Type(s)", "ID", "map_link",  "register_link",  "results_link", "start_time", "event_date","distance", "tag_line","end_time", "host", "contact address", "presented_by", "benefiting", "location" ]
        csv << arr
        Event.find(:all).each do | evt |
          next if evt.contact_email.blank?
          res = []
          res << evt.contact_email
          #parse the contact name. look for "(" and get everything on the left of it. if it doesnt exist, return the string as is
          name = evt.contact_name
          name = name[0, name.index("(")] if (name.nil? == false and name.index("(").nil? == false)
          res << name
          res << evt.contact_phone
          res << evt.name
          res << "#{evt.address_info}, #{evt.city} #{evt.state} #{evt.zip}"
          res << evt.description
          et_string = ""
          evt.event_types.each do | et |
            et_string += "#{et.name};"
          end

          et_string = et_string.chop
          res << et_string
          res << evt.id
          res << evt.map_link
          res << evt.register_link
          res << evt.results_link
          res << evt.start_time
          res << evt.event_date
          res << evt.distance
          res << evt.tag_line
          res << evt.end_time
          res << evt.host
          res << "#{evt.contact_address}, #{evt.contact_city} #{evt.contact_state} #{evt.contact_zip}"
          res << evt.presented_by
          res << evt.benefiting
          res << evt.location

          csv << res
        end
    end

  end
		
  def self.calculate_coupon_in_reg
      EventRegistration.find(:all, :conditions => ["processed = true AND coupon_id IS NOT NULL"]).each do | reg|
          #compare the cost to the race fee. if it's the same, deduct the coupon code
          if reg.cost.to_f == reg.race.current_fee(reg.created_at).to_f
              print "reg #{reg.id}: cost is #{reg.cost}, has coupon #{reg.coupon.code} (#{reg.coupon.value}), should be #{reg.cost.to_f - reg.coupon.value.to_f}\n"
              reg.cost = reg.cost.to_f - reg.coupon.value.to_f
              reg.save
          end
       end
       return true
  end
end
