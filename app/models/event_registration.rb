class EventRegistration < ActiveRecord::Base
	belongs_to :rm_user
	belongs_to :team
	belongs_to :event
	#belongs_to :registration_entry_type
	has_many :merchandise_orders
	has_many :answers
	has_one :relay_team
	has_one :team_entry
	has_many :relay_entries, :through => :relay_team
	belongs_to :race
	belongs_to :coupon
	
	named_scope :processed, :conditions => 'processed IS TRUE'
	#accepts_nested_attributes_for :answers, :allow_destroy => true

	attr_protected :id, :event_id, :race_id, :rm_user_id, :is_manual, :cost, :service_fee, :invoice_code, :processed, :status
	validates_presence_of :first_name, :last_name, :sex, :email
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  attr_accessor :none_us_state
  
  acts_as_audited #:only => [:race_id, :event_id]
	
	REG_TYPES_STR= ["Online and Manual Entries", "Online Entries Only", "Manual Entries Only"]
	REG_SORT_STR= ["Registration Date", "Last Name"]
	
	PAST_STR={"24 hours" => 1, "week" => 2, "2 weeks" => 3, "month" => 4, "all" => 5}
	
	def validate
		errors.add_on_empty %w( birthday ) unless is_manual
		#validate that birthday is entered correctly
		#regex = /\d{4}\-\d{2}\-\d{2}/
		#logger.info "birthday '#{birthday}' regex = #{(birthday.to_s =~ regex)}\n"
		#errors.add_to_base "Birth Date must be in the following format: mm/dd/yyyy" unless ((birthday.to_s =~ regex) == 0)
		errors.add_to_base "Emergency contact is required" if (event.is_contact_mandatory and em_con_name.blank?)
		errors.add_to_base "Emergency contact relationship is required" if (event.is_contact_mandatory and em_con_relationship.blank?)
		errors.add_to_base "Emergency phone number is required" if (event.is_contact_mandatory and em_con_phone.blank?)
		errors.add_to_base "License number is required" if (race.license_req and license_num.blank?)
		if event.id == 5239 or  event.id == 5226 or event.id == 5238
			errors.add_to_base "Please answer if this is your first triathlon." if first_tri.blank?
			errors.add_to_base "Please answer if this your first open water swim?" if open_swim.blank?
		end
		if (race.has_minimum_age)
			#get age
			age = EventRegistration.race_age(birthday, race.start_time)
  			errors.add_to_base("You must be at least #{race.minimum_age} years old to register for this event.") unless age >= race.minimum_age
  		end
        #team selection specific
        errors.add_to_base "Please select a team" if (race.supports_team and team_id.blank?)
        #team creation specific validations
        if race.supports_team_creation
            errors.add_to_base "Team name is required" if club_team.blank?
            errors.add_to_base "Team type is required" if team_type.blank?
            #check that we dont already have a team with that name, in that event
            errors.add_to_base "Team '#{club_team}' already exists. Please select a different name." if Team.find_by_event_id_and_name(self.event_id, club_team).nil? == false
        end
        if status == "Trash"
        	errors.add_to_base "Refund amount cannot be greater than registration cost" if (cost.to_f < refund_amount.to_f)
        	errors.add_to_base "Refund amount cannot be a negative numer" if (0 > refund_amount.to_f)
        end
	end
	
	def before_save
	 #if we the country is not the us, make sure to store the other state
	 if self.country != "united_states" and self.none_us_state.blank? == false
	   print 'setting state\n'
	   self.state = self.none_us_state
	 end
	end
	
	def after_save
		unless (race.nil? or processed == true)
			if race.is_relay == false or race.is_relay.blank?
				relay_team.delete unless relay_team.blank?
			end
		end
		event.registration_limit_notification if processed == true
		#check if we need to send the cancellation notification
		if (status == "Trash" and refund_processed.nil? and refund_amount.to_f > 0)
			RNotifier.deliver_cancellation_email(self)
			self.refund_processed = false
			self.save(false)
						
		end
	end
	
	def self.send_to_trash(reg)
		#reg = self.find(id)
		reg.processed = false
		reg.status = "Trash"
		#setup the refund amount
		reg.save
		#reg
	end
	
	def self.uncancel(reg)
		#reg = self.find(id)
		reg.processed = true
		reg.status = "Completed"
		reg.save()
	end
	
	def self.paginate_reg_records(search_request, page, event_id, per_page=25, sort=nil, current_user=nil)
		#default sort order
		if sort.nil?
			sort = "last_name ASC"
		end
		search_req = search_request
	    conds = ['processed = ?', true]
	    
	    
		
		if search_req.nil? == false
			if search_req[:show_all_events].to_i == 1
		    	#go through the managed event for the user
		    	data = " AND event_id IN ("
			    current_user.managed_events.each do |evt|
		    		data = data + " #{evt.id},"
		    	end
		    	data = data.chop
		    	data = data + ")"
			  	conds[0] = conds[0] + data
		    else
		    	
			  	conds[0] = conds[0] + " AND event_id = ?"
				conds << event_id
		    end
		    
			unless search_req[:race].blank?
				conds[0] = conds[0] + " AND race_id = ?"
				conds << search_req[:race]
			end
			unless search_req[:email].blank?
				conds[0] = conds[0] + " AND email = ?"
				conds << search_req[:email]
			end
			unless search_req[:city].blank?
				conds[0] = conds[0] + " AND city = ?"
				conds << search_req[:city]
			end
			unless search_req[:phone].blank?
				conds[0] = conds[0] + " AND phone = ?"
				conds << search_req[:phone]
			end
			unless search_req[:last].blank?
				conds[0] = conds[0] + " AND last_name = ?"
				conds << search_req[:last]
			end
			unless search_req[:first_name].blank?
				conds[0] = conds[0] + " AND first_name = ?"
				conds << search_req[:first_name]
			end	
			unless search_req[:invoice].blank?
				conds[0] = conds[0] + " AND invoice_code = ?"
				conds << search_req[:invoice]
			end		
			unless search_req[:lic_code].blank?
				conds[0] = conds[0] + " AND license_num = ?"
				conds << search_req[:lic_code]
			end
			
		else
			conds[0] = conds[0] + " AND event_id = ?"
			conds << event_id
		end
		
		return EventRegistration.paginate(:page => page,:per_page => per_page, :conditions => conds, :order => sort)
			
	end
	
	def self.race_age(birthday, race_date)
		begin
			date_obj = DateTime.parse(race_date.to_s) 
	  		age = (date_obj - birthday) / 365.25 # or (1.year / 1.day)
	  		age.to_i
  		rescue
  			return 0
  		end
	end
	
	def self.year_end_age(birthday, race_date)
		begin
			date_obj = DateTime.parse(race_date.to_s)
			d = DateTime.new(date_obj.year,12,31,0,0,0) 
	  		age = (d - birthday) / 365.25 # or (1.year / 1.day)
	  		age.to_i
  		rescue
  			return 0
  		end
	end
	
	def existing_birthday()
    	return birthday.strftime("%m/%d/%Y") if !birthday.nil?
    	return ""
    end
    
    def description_for_contact
    	"#{first_name} #{last_name}, #{address}, #{city}, #{state} #{zip}"
    end
    
    def self.calculate_service_fee(subtotal, direct = false, event_id=nil)
      
      if event_id
        #special cases
    	  return 0 if [7337, 7338, 7358, 7359, 7360, 7361, 6425, 7362, 7384, 7395, 7396, 7397, 7398, 7399, 7363].include?( event_id)
      end
		  if direct
        return ( 5.0 * subtotal.to_f ).round.to_f / 100
    	end

    	if subtotal.to_i > 700  # SMR_NOTE : No service fee for event 6435
    		return 0
    	end

      if (subtotal.to_i == 0 or subtotal.to_i > 999)
      	return 0
      else
        fee = 1.00 + 0.05 * subtotal.to_f

    	  # round the fee to 2 decimal places
    	  fee = (fee * 100).round.to_f / 100
	    
    	  if fee < 2.5
    	    return 2.5
    	  else
    	    return fee
    	  end
    	end
    end
    
    def usat_fee
    	#print license_num
    	
    	if relay_team.blank?
    		if license_num == "one-day license"
	    		age = EventRegistration.race_age(birthday, race.start_time)
	    		if age > 17
	    			return 10
	    		else
	    			return 5
	    		end
	    	else
	    		#print "returning zero"
	    		return 0
	    	end
	    else
	    	res = 0
	    	relay_team.relay_entries.each do |entry|
	    		if entry.license_num == "one-day license"
		    		age = EventRegistration.race_age(entry.date_of_birth, race.start_time)
		    		if age > 17
		    			res += 10
		    		else
		    			res += 5
		    		end
		    	else
		    		print "returning zero"
		    		res += 0
		    	end
	    	end
	    	return res
    	end
    	
    end
    
    def av_relay_entries
    	if relay_team.nil? or relay_team.relay_entries.size == 0
    		res = Array.new
    		race.max_relay_size.times do |x|
   				ent = RelayEntry.new
   				#for the first one, populate with the reg info
   				if x == 0
   					ent.first_name = first_name
   					ent.last_name = last_name
   					ent.gender = sex
   					ent.date_of_birth = birthday.strftime("%m/%d/%Y")
   					ent.tshirt = tshirt
   					ent.email = email
   					ent.license_num = license_num
   					ent.em_con_name = em_con_name
   					ent.em_con_phone = em_con_phone
   				end
   				res << ent
			end 
			return res
    	else
    		res = Array.new
    		count = 0
    		relay_team.relay_entries.each do |entr|
   				ent = entr.clone
   				res << ent
   				count += 1
			end 
			while count < race.max_relay_size
				ent = RelayEntry.new
   				res << ent
   				count += 1
			end
			return res
    		 
    	end
    end
    
    def twitter_feed_text
    	if event.id == 4706
    		return "Just+registered+for+@marathon_sports+Super+Sunday+5K/10K+on+Feb+7th+using+@racemenu+http://bit.ly/ss2010"
    	else
    		return "I+just+registered+for+the+" + event.name.gsub(" ", "+") + "+on+#{event.event_date.strftime('%d-%b-%y')}+using+@racemenu+register+here+#{tiny_url}"
    	end
    end
    
    def invoice_name
    	res = event.name
    	extra_races.each do | race |
    		res += ", #{race.event.name}"
    	end
    	res
    end
    
    def tiny_url
    	if event.id == 4621
    		return "http://tr.im/E7Gi"
    	elsif event.id == 4622
    		return "http://tr.im/E7EB"
    	else
    		return event.valid_url(event.register_link)
    	end
    end
    
    def self.profile_registrations(user, other_ids = [])
    	res = Hash.new
    	regs = user.event_registrations.find_all_by_processed(true) + EventRegistration.find(other_ids)
    	regs.each do |reg|
    		unless res.has_key?("#{reg.first_name}-#{reg.last_name}-#{reg.address}-#{reg.city}-#{reg.state}-#{reg.zip}")
    			res["#{reg.first_name}-#{reg.last_name}-#{reg.address}-#{reg.city}-#{reg.state}-#{reg.zip}"] = reg
    		end
    	end
    	
    	res.values
    end
    
    def activate_related
    	#goes through each of the related 
    	extra_races.each do | race |
    		#clone the ereg
    		reg = clone
    		#set race and event
    		reg.race = race
    		reg.event = race.event
    		reg.rm_user = rm_user
    		#set relay info if necessary
    		if race.is_relay and self.race.is_relay
    			rel_team = relay_team.clone
    			relay_team.relay_entries.each do | entry |
    				rel_team.relay_entries << (entry.clone)
    			end
    			reg.relay_team = rel_team
    		end
    		#HACK for BB - set the custom questions
    		#if event.id == 7358 or event.id == 7359 or event.id == 7360 or event.id == 7361
    		  
    		#end
    		#set cost and service
    		reg.service_fee = EventRegistration.calculate_service_fee(race.current_fee( created_at ).to_f + reg.usat_fee.to_f, false, reg.event_id)
    		reg.cost = race.current_fee( created_at ).to_f + reg.usat_fee.to_f
    		#save
    		reg.save
    		
    		#send notifier email
    		RNotifier.deliver_generic_reg_email(reg)
    		RNotifier.deliver_internal_reg_audit_email(reg)
    		if EventSignup.find_by_event_id_and_rm_user_id(reg.event.id, reg.rm_user.id) == nil
	  			add_to_mrm = EventSignup.new
	      		add_to_mrm.event_id = reg.event.id
	      		add_to_mrm.rm_user_id = reg.rm_user.id
	      		#add_to_mrm.reg_type = 2
	      		add_to_mrm.save
			end
    	end
    	#set the service fee and cost of the original reg
    	service_fee = EventRegistration.calculate_service_fee(race.current_fee( created_at ).to_f + usat_fee.to_f, false, event_id)
    	cost = race.current_fee( created_at ).to_f + usat_fee.to_f
    	save

        #if we have a team assigned to it, create a team entry
        unless team_id.blank?
            ent = TeamEntry.new
            ent.approved = false
            ent.team_id = team_id
            ent.event_registration_id = self.id
            ent.save
            #send email to team captain informing of a new member
            #RNotifier.deliver_team_entry_added_email(ent)
            self.processed = false
            save
        end

        #handle team creation
        if self.race.supports_team_creation
            #create a team
            t = Team.create :name => self.club_team, :cpt_first_name => self.first_name, :cpt_last_name => self.last_name,
             :email => self.email, :address => self.address, :city => self.city, :state => self.state, :zip => self.zip, :phone => self.phone, :team_type => self.team_type
             
              
            #set attr manual
            t.approved = true
            t.race_director_id = self.rm_user_id
			t.event_id = self.event_id
			t.save
            #create the first entry
            ent = TeamEntry.new
            ent.approved = true
            ent.team_id = t.id
            ent.event_registration_id = self.id
            ent.save
            #send a notification to the RD that a team has been added
            RNotifier.deliver_team_added_email(t, self.event_id, "RD_TEAM_ADD")
            #send a notification to the user that the team is added, and how to manage it
            RNotifier.deliver_team_added_email(t, self.event_id, "USER_TEAM_ADD", self.email)
        end
    end
    
    def extra_races
    	extra_races = Array.new
    	unless extra_regs.blank?
			extra_regs.split(',').each do | cnd| 
				print "extra_races: id= #{cnd}\n"
				frace = Race.find(cnd)
				extra_races << frace
			end
		end
		extra_races
    end
    

	# ====================================================================================
	# Fee Calculation
	# ====================================================================================
	
	def fee( with_coupon=true, with_usat=true )
		fee_value = race.current_fee( created_at ).to_f

		if with_usat
			fee_value += usat_fee.to_f
		end

		if with_coupon
			unless coupon.blank?
				fee_value = fee_value - coupon.value
			end
			if fee_value < 0
				fee_value = 0
			end
		end

		return fee_value
	end

	# extra races fee
	def extra_races_fee
		fee_value = 0

		#print "adding initial #{race.id}: #{(race.current_fee.to_f + usat_fee.to_f)}\n"
		#goes through each of the related 
		extra_races.each do | frace |
			#print "adding #{frace.id}: #{(frace.current_fee.to_f + usat_fee.to_f)}\n"
			if frace.id == extra_races.last.id
				#hack
				fee_value += (frace.current_fee( created_at ).to_f + usat_fee.to_f)
			else
				fee_value += (frace.current_fee( created_at ).to_f + usat_fee.to_f)
			end
		end
		return fee_value
	end

	def entry_fee( with_coupon = true, with_usat = true )
		fee_value = fee( with_coupon, with_usat )

		fee_value += extra_races_fee

		return fee_value
	end

	# total merchandise cost
	def total_merchandise_cost
		@total_merchandise_cost ||= merchandise_orders.inject(0){|sum, order| sum += order.merchandise_item_option.cost * order.quantity }
	end

	# entry fee + usat fee + extra races fee + merchandise cost
	def total_cost(with_coupon=true, with_usat=true)

		cost = entry_fee( with_coupon, with_usat )
		cost += total_merchandise_cost
		cost -= discount
		cost = 0 if cost < 0

		return cost
	end

	# service fee on entry fee + usat fee + extra races fee ( 1 + 5% )
	# + service fee on merchandise cost ( 5% )
	def total_service_fee(with_coupon=true, with_merchandise = true)
	  
	  
	  
		service_fee_t = 0

		fee_value = fee( with_coupon, true )
		service_fee_t += EventRegistration.calculate_service_fee( fee_value, false, event_id )
		service_fee_t += EventRegistration.calculate_service_fee( total_merchandise_cost, true, event_id ) if with_merchandise


		#goes through each of the related 
		extra_races.each do | frace |
			if frace.id == extra_races.last.id
				#hack
				fee_value = frace.current_fee( created_at ).to_f - discount.to_f
				service_fee_t += EventRegistration.calculate_service_fee(fee_value + usat_fee.to_f, false, event_id)
			else
				service_fee_t += EventRegistration.calculate_service_fee(frace.current_fee( created_at ).to_f + usat_fee.to_f, false, event_id)
			end
		end

		return service_fee_t
	end

	# entry fee + usat fee + extra races fee + merchandise cost + service cost on all
	def total_cost_with_service_fee( with_coupon=true, with_usat=true )
		total_cost(with_coupon,with_usat) + total_service_fee(with_coupon)
	end

	# discount
	def discount
		#hack for bill
		found_5239 = false
		found_5226 = false
		found_5238 = false

		if (event.id == 5239 and race.is_relay == false)
			found_5239 = true
		elsif (event.id == 5226 and race.is_relay == false)
			found_5226 = true
		elsif (event.id == 5238 and race.is_relay == false)
			found_5238 = true
		end

		extra_races.each do | race |
			event = race.event
		if (event.id == 5239 and race.is_relay == false)
			found_5239 = true
		elsif (event.id == 5226 and race.is_relay == false)
			found_5226 = true
		elsif (event.id == 5238 and race.is_relay == false)
			found_5238 = true
		end
		end
		
		found_7038 = false
		found_7047 = false
		
		if (event.id == 7038)
			found_7038 = true
		elsif (event.id == 7047 and race.id != 7887)
			found_7047 = true
		end

		extra_races.each do | race |
			event = race.event
			if (event.id == 7038)
				found_7038 = true
			elsif (event.id == 7047 and race.id != 7887)
				found_7047 = true
			end
		end
		

		if (found_5239 and found_5226 and found_5238)
			return 15
		elsif (found_7038 and found_7047)
			return 10
		else
			#hack
			#return 20
			return 0
		end

	end
	
	def to_label
		"#{first_name} #{last_name} (#{event.name } - #{race.name})"		
	end

end
