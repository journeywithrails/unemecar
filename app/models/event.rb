require 'csv'

class Event < ActiveRecord::Base

	has_many :event_signups, :dependent => :destroy
	has_many :rm_users, :through => :event_signups
	
	has_many :teams
	has_many :registration_entry_types
	has_many :races, :dependent => :destroy, :order => :race_group_order
  has_many :open_races, :class_name => 'Race', :dependent => :destroy, :order => :race_group_order, :conditions => ['registration_open is not false']
	has_many :race_groups, :order => :group_order
	has_many :event_registrations
	has_many :merchandise_orders, :through => :event_registrations
	has_many :merchandise_items
	has_many :questions, :order => :q_order
	has_many :coupons
	has_many :event_payments
	has_many :waitlists
	has_many :invitations
  
	has_many :event_owners
  
	has_many :owners, :through => :event_owners, :source => :owner, :class_name => 'RmUser'
	
	belongs_to :rd_contact_info, :class_name => "ContactInfo", :foreign_key => "rd_contact_info_id"
	belongs_to :contact_info
	belongs_to :event_series
	belongs_to :header_image, :class_name => "Image"
         	
	has_and_belongs_to_many :event_types
	has_one :notification_setting
	
	accepts_nested_attributes_for :notification_setting
	
	before_save :check_rd_init
	after_create :add_default_questions
	attr_protected :manage_type
	attr_accessor :real_id

	named_scope :currently_active, :conditions => 'is_register_open IS TRUE and approved IS TRUE'
	
	acts_as_audited
	
	#event management type
	BASIC = 1 #no RD section, only managed via the add_event form
	RD = 2 #RD section

	MGT_TYPE = ["None", "Basic", "RD"]
	
	#validations
	#validates_length_of :description, :maximum=>250
	
	#for clearer urls
	def to_param
		"#{id}-#{name.gsub(/[^a-z1-9]+/i, '-')}" unless name.nil?
	end
  
	has_attached_file :image, :styles => { :thumb => "100x100>"},
		:url  => "/assets/events/:id/:style/:basename.:extension",
		:path => ":rails_root/public/assets/events/:id/:style/:basename.:extension"
	validates_attachment_size :image, :less_than => 1.megabytes
	
	
	#CSV constants
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
	COL_EV_TYPE=15
	
	#model callbacks
	def before_create
		#create a default race group
		if race_groups.size == 0
			rg = RaceGroup.create :is_default => true, :title => "Main Group", :group_order => 1
			race_groups << rg
		end
	end
	
	def registration_limit_reached?
		entry_limit && entry_limit <= event_registrations.processed.size
	end

	def has_waiting_list?
		!races.select{|s| s.has_waiting_list and !s.can_reg }.empty?
	end
	
	
	# Add questions to event by default
	# Used to replace T-Shirt question from hardcoding to custom questions
	def add_default_questions
		# tshirt
		question = Question.create( :event_id => id, :title => 'T-Shirt', :abbreviation => 'T-Shirt', :explanation_text => 'Select T-Shirt Size',
									:q_order => 10, :question_type => Question::DROPDOWN_LIST, :is_required => true )
		if question
			question.question_options << QuestionOption.create( :q_order => 10, :title => 'X-Small' )
			question.question_options << QuestionOption.create( :q_order => 20, :title => 'Small' )
			question.question_options << QuestionOption.create( :q_order => 30, :title => 'Medium' )
			question.question_options << QuestionOption.create( :q_order => 40, :title => 'Large' )
			question.question_options << QuestionOption.create( :q_order => 50, :title => 'X-Large' )
		end
	end
	def has_tshirt_question?
		#return true if id and id == 6425  # NOTE_SMR : Remove tshirt for event id 6425
		#questions.find( :first, :conditions => "title like '%T-Shirt%'" )
		return false if id == 5238 or id == 5239 or id == 5226
		return true
	end
	
	def discipline
	  return nil if event_types.size==0 
	  return event_types[0].discipline
  	end
	
		
	def contact_name
		if contact_info.nil? or contact_info.name.blank?
			read_attribute(:contact_name)
		else
			contact_info.name
		end
	end
	
	def contact_phone
		if contact_info.nil? or contact_info.phone.blank?
			read_attribute(:contact_phone)
		else
			contact_info.phone
		end
	end
	
	def contact_email
		if contact_info.nil? or contact_info.email.blank?
			read_attribute(:contact_email)
		else
			contact_info.email
		end
	end

	# print date - name
	def dn
	  return "#{event_date} - #{name}"
	end
	
	#=================================================
  
  def registrations_by_time(time_start = '', time_end = nil )
	time_end = Time.now if time_end.nil?
    event_registrations.processed.find(:all, :conditions => ['created_at >= ? and created_at <= ?', time_start, time_end ])
  end

  def registrations_value( registrations )
    registrations.inject(0){|sum, reg| sum += reg.cost.to_f }
  end
  
  def orders_by_time(time_start = '', time_end = nil)
	time_end = Time.now if time_end.nil?

    merchandise_orders.find(:all, :select => "count(*) as item_count, mio.title, merchandise_orders.quantity, mio.cost", 
                                  :joins => "inner join merchandise_item_options mio on merchandise_orders.merchandise_item_option_id = mio.id", 
                                  :conditions => ['merchandise_orders.created_at >= ? and merchandise_orders.created_at <= ?', time_start, time_end ],
                                  :group => "mio.id"
                            )
  end
  #def orders_by_time(time_start = '', time_end = nil )
  #  time_end = Time.now if time_end.nil?
  #  merchandise_orders.find(:all,  :conditions => ['merchandise_orders.created_at >= ? and merchandise_orders.created_at <= ?', time_start, time_end ])
  #end
  def orders_value(orders)
    orders.inject(0){|sum, mo|  sum += mo.cost.to_i * mo.item_count.to_i }
  end
  def orders_count(orders)
    orders.inject(0){|sum, mo|  sum += mo.item_count.to_i }
  end
  
  # ============================================ 
  
	def display_image_url
		if self.id.to_s == "1103" 
			"http://racemenu.com/images/may28.gif"
		elsif self.id.to_s == "1575" 
			"http://racemenu.com/images/jn28.gif"
		elsif self.id.to_s == "1620" 
			"http://racemenu.com/images/jul30.gif"
		elsif self.id.to_s == "1646" 
			"http://racemenu.com/images/aug20.gif"
		elsif self.id.to_s == "1659" 
			"http://racemenu.com/images/sep10.gif"
		elsif self.id.to_s == "4609" 
			"http://racemenu.com/images/rb5k300.jpg"  
		elsif self.id.to_s == "4611" 
			"http://racemenu.com/images/4k09-racemenu.jpg"  
		elsif self.id.to_s == "4621" 
			"http://www.racemenu.com/images/turkeytrot_100x100.gif"  
		else 
			"http://racemenu.com/images/racemenu_icon.gif"
		end 
	end
	
		
	###################################
	
	#functions related to showing friends with a given event added
	
	def list_users
	  #make sure that this Event.find(3830).list_users does not return the logged in user
	  #down the road, make another function that uses this to see if any friends have added the event
	  return self.rm_users.delete_if{ |user| user == current_user }
  end
  
  #this will be used to see if an individual event has friends or not - if it does, display button "Friends" in simple table mode to let them know
  def list_friends(fb_session)
    if fb_session.blank?
      return self.list_users
    else
      userfriends = current_user.top_friends_user_output(fb_session.user.friends, 99999, "rm_user_id")
      if userfriends == nil
        return self.list_users
      else
        array = []
        self.list_users.each{ |user|
	        if userfriends.include?(user)
	          array << user
          end
	      }
	      return array.sort_by{ rand }
      end
    end
  end
  
  #this will be used for the display - should show all ppl with the event added
  def order_friends_then_users(fb_session)
    if fb_session != nil
      #userfriends = current_user.top_friends_user_output(fb_session.user.friends, 99999, "rm_user_id")
      userfriends = self.list_friends(fb_session)
      compile = userfriends << self.list_users.delete_if{ |user|
	      userfriends.include?(user)
	    }
	    return compile.delete_if{ |user|
	      user == []
	    }
    else
      return self.list_users
    end
  end
	
	###############################
	
	
	
	#returns a hash of events that were imported. if do_save is set to true, it those events will be saved in the database.
	def self.import_from_csv(csv_data, do_save=true)
		
		res_events = Hash.new
		#CSV.open(csv_data, 'r') do |row|
		CSV.open(csv_data, 'r', "\t") do |row|
			puts 'importing ' + row[COL_NAME].to_s + '\n'
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
    		ev.discipline = Discipline.find_by_name(row[COL_DISCIPLINE].to_s.capitalize)
    		
    		ev_type_name = row[COL_EV_TYPE].to_s
    		cindex = ev_type_name.index(" (")
    		if cindex.nil? == false
    			cand = ev_type_name[0, cindex]
    			#special code for marathons, and tris
    			if cand == "sprint" #dis: mutlisport, et: sprint
    				ev.discipline = Discipline.find_by_name("Multisport")
    			elsif cand == "13.1"
    				ev.discipline = Discipline.find_by_name("Running")
    				cand = "half marathon"
    			elsif cand == "26.2"
    				ev.discipline = Discipline.find_by_name("Running")
    				cand = "marathon"
    			elsif cand == "half-ironman"
    				ev.discipline = Discipline.find_by_name("Multisport")
    				cand = "half ironman"
    			end
    			ev_type_name = cand
    		else
    			#check for duathlon and aquathon
    			if ev_type_name == "aquathon" 
    				ev.discipline = Discipline.find_by_name("Multisport")
    				ev_type_name = "aquathlon"
    			elsif ev_type_name == "duathlon"
    				ev.discipline = Discipline.find_by_name("Multisport")
    			end
    		end
    		
    		ev.event_type = EventType.find_by_name(ev_type_name)
    		
    		if do_save
    			ev.save!
			end
			
			#store it in the hash
			key = "#{ev.name}_#{ev.event_date.to_s}"
			res_events[key] = ev
  		end
  		return res_events
	end
	
	def self.paginate_event_records(search_request, page, is_result, per_page=25, sort=nil)
	  search_req = search_request
	  #puts "blah2"
	  #puts search_request.to_hash
	  
		now = DateTime.now
		if is_result
			dt = DateTime.yesterday
			d = DateTime.new(dt.year,dt.month,dt.mday,23,0,0)
			conds = ['event_date < ?', d]
			order = sort.nil? ? "events.event_date desc" : sort
		else
			#show anything that's from today's date
			d = DateTime.now
			
			#search based on from date input
			if search_req !=nil and search_req.from != nil
			  split_from = search_req.from.split("/")
			  unless split_from.last.nil?
			    d = DateTime.new(y=split_from.last.to_i, m=split_from.first.to_i, d=split_from.second.to_i, h=0, min=0, s=0)
		    end
		  end
		  
			conds = ['event_date >= ?', d]
			order = sort.nil? ? "events.event_date asc" : sort
		end
		
		conds[0] = conds[0] + ' AND approved = true'	
		
		
		unless search_req.nil?
			search_state = search_req['state']
			search_name = search_req['name'].capitalize
			search_city = search_req['city'].capitalize unless search_req['city'].blank?
			search_types = search_req['types']
			search_rad_state = search_req['rad_state']
			
			#date based search
			unless search_req.to.nil?
			  split_to = search_req.to.split("/")
			  unless split_to.last.nil?
			    d_to = DateTime.new(y=split_to.last.to_i, m=split_to.first.to_i, d=split_to.second.to_i, h=23, min=59, s=59)
			    puts d_to
			    conds[0] = conds[0] + ' AND event_date <= ? '
			    conds << d_to
		    end
		  end
			
			
			#region/state based search
			if search_state.blank? or search_state == "None" or search_state == "All"
			  #this is the radius based search.... not yet at all functional
  			unless search_city.blank? or search_city == "City"
  				conds[0] = conds[0] + " AND city = ? "
  				conds << search_city
  			end			
  			
  			unless search_rad_state.blank? or search_rad_state == "State"
  			  conds[0] = conds[0] + " AND state = ? "
  				conds << search_rad_state
  			end

			  
		  else
		    #this searches within one region or one state
			  if search_state == "New England"
			    conds[0] = conds[0] + " AND (state = 'MA' OR state='VT' OR state='CT' OR state='RI' OR state='NH' OR state='ME' )"
		    else
		      if search_state == "Mid-Atlantic"
  			    conds[0] = conds[0] + " AND (state = 'DE' OR state='DC' OR state='MD' OR state='NJ' OR state='NY' OR state='PA' )"
  		    else
  		      if search_state == "Midwest"
    			    conds[0] = conds[0] + " AND (state = 'IL' 
    			    OR state='IN' OR state='IA' OR state='KS' 
    			    OR state='MI' OR state='MN' OR state='MO' 
    			    OR state='NE' OR state='ND' OR state='OH'
    			    OR state='SD' OR state='WI'  )"
    		    else
    		      if search_state == "The South"
      			    conds[0] = conds[0] + " AND (state = 'AL' 
      			    OR state='AR' OR state='FL' OR state='GA' 
      			    OR state='KY' OR state='LA' OR state='MS' 
      			    OR state='NC' OR state='SC' OR state='TN'
      			    OR state='VA' OR state='WV'  )"
      		    else	  
      		      if search_state == "The Southwest"
        			    conds[0] = conds[0] + " AND (state = 'AZ' OR state='NM' OR state='OK' OR state='TX' )"
        		    else
        		      if search_state == "The West"
          			    conds[0] = conds[0] + " AND (state = 'AK' 
          			    OR state='CA' OR state='CO' OR state='HI' 
          			    OR state='ID' OR state='MT' OR state='NV' 
          			    OR state='OR' OR state='UT' OR state='WA'
          			    OR state='WY' )"
          		    else
				            conds[0] = conds[0] + " AND state = ?"
				            conds << search_state
			            end
			          end
			        end
			      end
			    end
			  end
			end

			unless search_name.blank?
				conds[0] = conds[0] + " AND name like ?"
				conds << "%" + search_name + "%"
			end
			
			
			unless search_req.distance_display.blank? or search_req.distance_display == "Distance"
			  #still need more code to search through distance of each race as well... alain said not to do for aug 1st launch though
			  start_distance = search_req.distance_display.split(" ").first
        end_distance = search_req.distance_display.split(" ").last
        
        
        if start_distance.last == "m"
          start_distance = start_distance.to_i * 0.62137
        else
          start_distance = start_distance.to_i
        end
        
        if end_distance.last == "m"
          end_distance = end_distance.to_i * 0.62137
        else
          end_distance = end_distance.to_i
        end
        
        
      unless start_distance <= 3.1 and end_distance >= 200
        use_races = ""
        if start_distance <= 3.1 and end_distance >= 3.1
          use_races << "1,"
        end
        if start_distance <= 4.97 and end_distance >= 4.97
          use_races << "2,"
        end
        if start_distance <= 6.2 and end_distance >= 6.2
          use_races << "3,"
        end
        if start_distance <= 5 and end_distance >= 5
          use_races << "4,"
        end
        if start_distance <= 10 and end_distance >= 10
          use_races << "5,"
        end
        if start_distance <= 13.1 and end_distance >= 13.1
          use_races << "6,"
        end
        if start_distance <= 26.218 and end_distance >= 26.218
          use_races << "7,"
        end
        #5k(1), 8k(2), 10k(3), 5mi-4, 10mi-5, half marathon-6, marathon-7
        conds[0] = conds[0] + " AND event_types_events.event_type_id IN (" + use_races.chop + ") "
      end
        
        
		  end
			  
			
			
			
			
			if search_req['types'].nil? == false and search_req['types'].empty? == false
				data = ""
		      	#search_req['types'].each_index do | index |
		      	#	if index == 0
		      	#		data = data + "AND ("
	      		#	else
	      		#		data = data + " OR "
	      		#	end
	      		#	data = data + "event_type_id = " + search_req['types'][index]
		      	#	
		  		#end
		  		
		  		data = " AND event_types_events.event_type_id IN ("
		        first = true
		        search_req['types'].each_index do | index |
		        	if (!first)
		            	data = data + ","
		          	else
		            	first = false
		          	end
		          	data = data + "#{search_req['types'][index]}"
		        end
        
		  		data = data + ")"
		  		conds[0] = conds[0] + data
		  		 
		  	end      
			
			#@conds << 'state = ' unless @search_state == "None"
		end
		return Event.paginate(:conditions => conds, :order => order,
			:page => page,
			:per_page => per_page,
			:select => "DISTINCT events.*",
			:include => :event_registrations,
			:joins => "join event_types_events on event_types_events.event_id=events.id")
			
	end
	
	def is_registerable?
		return false unless is_register_open
		return false if races.registerable.empty?
		true
	end
	
	#hack
	def dname
		name		
	end
	def event_types_as_cs_string
	  string = ""
	  event_types.each  { |e| string = string + "- " + EventType.find(e).name + "<br/>" }
      return string.chop.chop
	end
	
	def valid_url(url)
		unless url.blank?
			if /^http:/.match( url )
				url
			else
			   'http://' + url
			end
		end
	end
	
	def self.lookup_similar_events(name, city, state)
		d = Time.now
		res = Event.find(:all, :conditions => ["event_date > ? and approved = true and state = ? and city = ? and name = ?",d , state, city, name])
		#next, do a search just by name
		res2 = Event.find(:all, :conditions => ["event_date > ? and approved = true and name = ?",d , name])
		#next, do a loose name-based search
		res3 = Event.find(:all, :conditions => ["event_date > ? and approved = true and name LIKE ?",d , "%#{name}%"])
		#go one by one and if it doesnt exist, add it
		res2.each do | evt |
			if res.include?(evt) == false
				res << evt
			end
		end
		res3.each do | evt |
			if res.include?(evt) == false
				res << evt
			end
		end
		#return 
		res
		
	end
	
	def cats_for_select
		a = Hash.new
		#a << "All Entries"
		#if self.race_groups.size > 1
		#	self.race_groups.find(:all, :order => "group_order ASC").each do | grp|
		#		a << "- #{race.name.upcase}"
		#		grp.races.each do | race| 
		#			a << "-- #{race.name} (#{race.event_type.name})"
		#		end
		#	end
		#else
			self.races.each do | race| 
				a["-- #{race.name} (#{race.event_type.name})"] = race.id
			end
		#end
		a
	end
	
	def merch_cats_for_select
		a = Array.new
		a << "All Merchandise Orders"
		a
	end
	
	def create_new_group(name) #TODO_UNIT
		#get the group with the highest order
		can = race_groups.last
		#create a new group
		new_gr = RaceGroup.create :event => self, :title => name, :group_order => (can.group_order + 1)
		new_gr
	end
	
	def race_attributes=(race_attributes)
  		race_attributes.each do |attributes|
    		races.build(attributes)
  		end
	end
	
	def submitted_by
		RmUser.find(manage_type).title unless (manage_type.nil? or manage_type == BASIC or manage_type == RD)
	end
	
	def is_tri_event
		races.each do | race |
			if race.needs_tri_disc
				return true
			end
		end
		return false
	end

    def has_cap_left
		
		if entry_limit.nil?
			return true
		else
			return entry_limit > event_registrations.find_all_by_processed(true).size
		end
	end
	
	def short_contact_string
		res = ""
		if (contact_info.blank? == false and ((contact_info.show_name.blank? and contact_info.show_name.blank? and contact_info.show_name.blank?) == false))
			res += "#{contact_info.name} " if contact_info.show_name 
			res += "#{contact_info.phone}<br/>" if contact_info.show_phone 
			res += "#{contact_info.email} " if contact_info.show_email 
		else
			res = "#{contact_name} #{contact_phone}<br/> #{contact_email}"
		end
		res
	end
	
	def fname
    	@fname
  	end
  	def fname=(fname)
    	@fname = fname
  	end
  	def lname
    	@lname
  	end
  	def lname=(lname)
    	@lname = lname
  	end
  	
  	def real_id
  		self.id	
  	end
  	
  	def contact_info_details
		{
			:name => ( contact_info && contact_info.name ) || contact_name ,
			:email => ( contact_info && contact_info.email ) || contact_email ,
			:phone => ( contact_info && contact_info.phone ) || contact_phone 
		}
  	end
  	
  	def start_list_size
  		res = 0
  		races.each do |race|
  			res += race.procssed_registrations.size
  		end
  		res
  	end
  	
  	def check_rd_init
  		if (manage_type_changed? and manage_type == 2 and manage_type_was == 1)
  			#set the event and its races to closed
  			self.is_register_open = false
  			self.races.each do |race|
  				race.registration_open = false
  				race.save
  			end
  		end
  	end

	def notifier_emails
		return [notification_setting.notification_email] unless (notification_setting.nil? || notification_setting.notification_email.nil? )
		emails = []
		owners.each do |owner|
			emails << owner.email if owner.email and !owner.email.blank?
		end
		emails.uniq
	end

	def registration_limit_notification
		if notification_setting and notification_setting.rec_limit_notification
			full_races = races.select{ |r| r.registration_limit_reached? }
			if registration_limit_reached? or !full_races.empty?
				RNotifier.deliver_registration_limit_email( self, full_races, notifier_emails ) unless notifier_emails.empty?
			end
		end
	end
	
	def real_open_races
  	 res = []
  	 open_races.each do |race|
  	   res << race if (race.can_reg and race.is_relay == false)
  	 end
  	 res
	end

	def self.send_daily_report
		Event.currently_active.each do |event|

			notification_setting = event.notification_setting

			emails = event.notifier_emails
			next if emails.empty?

			# Daily Report
			if notification_setting and notification_setting.rec_daily_notification
				RNotifier.deliver_daily_event_report( event, emails )
			end

			# Limit Notification
			# event.registration_limit_notification

		end
	end
	
	### Relay team specific functions
	def needs_relay_team
		if id == 5226 or id == 5238 or id == 5239 or id == 6426 or id == 6894
			return false
		else
			#go through the races and see if one of the races is a relay
			races.each do |race|
				return true if race.is_relay
			end
			return false
		end
	end
	
  
	
		
end
