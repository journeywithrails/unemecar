class RegisterController < ApplicationController
	before_filter :for_activation, :login_required, :require_ssl
	skip_before_filter :verify_authenticity_token, :only => [:success]
	
	def index
		ev = params[:event]
		#hack - if it's 5261, switch to 5238
		if ev.to_i == 5261
			ev = 5239
		end
		session[:reg_event] = ev
		session[:race_options] = nil
		#check that the event can be regd
		@event = Event.find(session[:reg_event])
		
		
		if @event.is_register_open
			redirect_to :action => "registration_type", :event => params[:event]
		else
			redirect_to :controller => "event", :action => "show_detailed", :id => @event.id
		end
	end
	
	def waitlist
		flash[:error] = ""
		flash[:error] = "Please Select one Event" if params[:event].nil?
		flash[:error] += "Please Select one Race/category" if params[:race].blank?

		@event = Event.find(params[:event])
		@race = Race.find(params[:race])
		
		flash[:error] = "#{@race.name} has registration open. Can not join waitlist." if @race.can_reg
		flash[:error] = "#{@race.name} does not have waiting list enabled." unless @race.has_waiting_list and !@race.can_reg
		redirect_to :action => 'registration_type', :event => params[:event] and return unless flash[:error].blank?

		session[:race] = nil #params[:race]
		session[:reg_event] = nil #params[:event]

		if request.post?
			@waitlist = Waitlist.create(params[:waitlist])
			if @waitlist.save
				RNotifier.deliver_waitlist_email(@event, @race, @waitlist.name) unless @event.notifier_emails.blank?
				# TODO : Update EventSignup for waiting list. ??
				#es = EventSignup.find_by_event_id_and_rm_user_id(@event.id, current_user.id)
				#if es.nil?
				#	es = EventSignup.create :event => @event, :rm_user => current_user, :reg_type => 2
				#else
				#	es.reg_type = 2
				#	es.save
				#end
				redirect_to :action => :success_waitlist, :id => @waitlist.id
			end
		end
	end
  
	def success_waitlist
		@waitlist = Waitlist.find( params[:id] )
		@event = @waitlist.event
		@race = @waitlist.race
	end
  
  
  def activate
    flash[:error] = "Activation code is null" unless params[:activation_code]
    @invitation = Invitation.find_by_secret(params[:activation_code]) if params[:activation_code]
    if @invitation  and @invitation.disable!
      flash[:notice] = "You are registered for #{@invitation.event.name}: #{@invitation.race.try(:name)}"
      session[:reg_event] = @invitation.event.id
      session[:race] = @invitation.race.id
      redirect_to :action => :athlete_info and return
    else
      flash[:notice] = @invitation.nil? ? "The link is expired/used." : 
                              "This link has been expired at #{@invitation.expire_at.to_s}."
      session[:return_to] = nil
      redirect_to login_path
    end
  end
  
	def registration_type
     #~ render :text => "test" and return
     	#~ @event = Event.find(739)
		@event = Event.find(session[:reg_event])
   
		if @event.is_register_open == false
			redirect_to :controller => "event", :action => "show_detailed", :id => event.id
		end
		#check if the event is part of a series
		  
		#try to get the reg data
		if session[:race].nil? == false and @event.event_series.nil?
			@race = Race.find(session[:race]) 
		end
		
		@refered = session[:refered]
		@races = @event.races
		@race_options = session[:race_options]
		if request.post?
			#clear out the license
			
			#first, check if this is a series race
			if params[:revent].nil? == false
				found = false
				prace = nil
				praceid = nil
				race_options = {}
				extra = ""
				is_relay = false
				is_indiv = false
				can_reg = true
				race_cap = nil
				params[:revent].each do | event |
					if event[1]["fname"].to_i == 1
						race = event[1]["lname"]
						unless race.blank?
							rr = Race.find(race)
							race_options[event[1]["id"]] = race
							
							unless rr.blank?
								is_relay = (rr.is_relay == true) unless is_relay == true
								is_indiv = (rr.is_relay == false or rr.is_relay.nil?) unless is_indiv == true
							end
							#check if above capacity or registration closed
							can_reg = rr.can_reg
							if can_reg == false
								race_cap = rr
							end
							if found == true
								#add to extra
								extra += race.to_s + ","
							else
								found = true
								prace = race
								praceid = rr.event.id
								
							end
							
						end
					end
					
				end
				
				logger.debug { "#{race_options.inspect}" }
				if (is_relay and is_indiv) or can_reg == false
					found = false
				end
				
				if found
					session[:extra] = extra
					session[:race_options] = race_options
					session[:race] = prace
					session[:reg_event] = praceid
					session[:refered] = params[:refered]
					redirect_to :action => "athlete_info"
				else
					if is_relay and is_indiv
						flash[:error] = "Sorry, you can not register for both individual and team categories during the same registration process. Please change one of the categories."
					elsif can_reg == false
						flash[:error] = "We're sorry, category '#{race_cap.name}' in event '#{race_cap.event.name}' has reached capacity or registration is closed. Please select a different category."
					else
						flash[:error] = "Please select at least one event and category."
					end
				end
			
			
			else
				session[:extra] = nil
				if params[:race].nil?
					flash[:error] = "Please select a race."
                else
					#get the reg data
					@race = Race.find(params[:race])
										
					if !session[:reg_ids].nil? and !session[:reg_ids].empty?
						# TODO SMR handle multi reg. might need to loop. not sure about the purpose of this check
						@event_reg = EventRegistration.find(session[:reg_ids].first)
						unless (@race.license_req and @race.needs_tri_disc)
							@event_reg.license_num = nil
							@event_reg.save
						end
					end

					# TODO SMR setting race when multireg exists is problamatic
					# might need to cancel session[:reg_ids] or not set race
					session[:race] = params[:race]
					session[:race_options] = params[:race_options]
					session[:refered] = params[:refered]
					redirect_to :action => "athlete_info"
				end
			end
		end
	end
	
	def athlete_info
		session[:reg_ids] ||= []
		@event = Event.find(session[:reg_event])
		@race = Race.find(session[:race] )
		reg_id = nil

		if params[:reg_id]
			reg_id = params[:reg_id].to_i if session[:reg_ids].include?( params[:reg_id].to_i)
		elsif params[:add]
			reg_id = nil
		elsif params[:cancel]
			if session[:reg_ids].empty?
				redirect_to :action => 'athlete_info'
				return
			end

			if @race.is_relay
				redirect_to :action => "team"
			else
				redirect_to :action => 'merchandise'
			end
			return
		elsif !session[:reg_ids].empty? and !request.post?
			reg_id = session[:reg_ids].first
		end
	  
		@cand_regs = EventRegistration.profile_registrations(current_user, session[:reg_ids])
		
		
		# Load Event Registration Details
		unless reg_id.nil?
			@event_registration = EventRegistration.find_by_id(reg_id)  # fill fields with existing values

			#check if this is a processed reg, clear it from the cache
			if (@event_registration.nil? == false and @event_registration.processed == true)
				#clear the cache
				session[:reg_ids] = []
				session[:e_reg_to_reload] = nil
				session[:reg_total_cost] = nil
				@event_registration = EventRegistration.new
				@event_registration.first_name = current_user.first_name
				@event_registration.last_name = current_user.last_name
			end
		end

		# If not loaded, Create new Session
		if @event_registration.nil?
			@event_registration = EventRegistration.new
			@event_registration.first_name = current_user.first_name
			@event_registration.last_name = current_user.last_name
		end
							
		# Update
		if request.post?
			
			#set the event and reg_type on the reg
			@event_registration.event = @event
			@event_registration.race = @race
			
			#set the user
			@event_registration.rm_user_id = current_user.id
			
			@event_registration.update_attributes( params['event_registration'] )
			#set extras
			@event_registration.extra_regs = session[:extra]
			#set refered by
			@event_registration.refered_by = session[:refered]
			
			#store license if necessary
			if @race.needs_tri_disc and @race.license_req
				type = params[:usat]["license_type"]
				if type == "one-day license" or type == "pending"
					@event_registration.license_num = type
				end				
			end

			#hack
			if @event_registration.save
				session[:reg_ids] << @event_registration.id unless session[:reg_ids].include?( @event_registration.id )
				#if it's a relay race, send to the relay page
				if @race.is_relay
					redirect_to :action => "team"
				else
					if params[:commit] == "Register Another Person"
						redirect_to :action => 'athlete_info', :add => true
					else
						redirect_to :action => 'merchandise'
					end
				end
				 
				# Custom Questions
				if params[:question]
				params[:question].each do |qid, attributes|
					question = Question.find(qid.to_i)
					next unless question

					unless attributes[:answers].nil?   # for check-box
						old_answers = question.answers.find( :all, :conditions => { :event_registration_id => @event_registration.id } )
						question.question_options.each do |qp| 
							old_answer = old_answers.select{ |old| old.question_option_id == qp.id }
							if !attributes[:answers][qp.id.to_s].nil?
								if old_answer.empty?
									question.answers.create( :event_registration => @event_registration, :question_option_id => qp.id, :extra_info => nil )
								else
									old_answers.delete_if{ |old| old.question_option_id.to_s == qp.id.to_s }
								end
							end
						end
						old_answers.each do |old|
							old.delete
						end
					end

					unless attributes[:answer].blank?
						old_answer_id = attributes[:answer][:id]
						answer = question.answers.find( :first, :conditions => { :event_registration_id => @event_registration.id } )
						if answer
							answer.update_attributes(attributes[:answer])
						else
							answer = question.answers.create(:question_id => question.id, :event_registration => @event_registration)
							answer.update_attributes(attributes[:answer])
						end
					end 
				end
				end
			end
		end
    
	end
	
	
	def team
		if session[:reg_ids].nil? or session[:reg_ids].blank?
			redirect_to :action => 'athlete_info'
		end

		error = false
		@event = Event.find(session[:reg_event])
		@race = Race.find(session[:race] )
		@reg = EventRegistration.find(session[:reg_ids].first)
		@relay_team = @reg.relay_team
		
		if request.post?
			#handle merchandise here
			@relay = @reg.create_relay_team(params[:relay])
			#check that the team is valid
			if @relay.save == false
				error = true
				
			else
				@relay.relay_entries.delete_all
				@relay.reload
			end
			
			@entries = Array.new
			#
			size = params[:data]["reg_id"].to_i
			counter = 0
			params[:relay_entry].each do | entry |
				if counter == size
					break
					print "breaking-----\n"
				end
				counter += 1
				rel_entry = @relay.relay_entries.build(entry)
				type = entry["license_type"]
				#print entry["license_type"]
				if type == "one-day license" or type == "pending"
					rel_entry.license_num = type
				end
				rel_entry.validate
				if rel_entry.save == false
					error = true
				end
				
				
				
				
				
			end
			
			@entries = @relay.relay_entries
			#hack - adding more relay entries manually just in case, but not saving them
			count = @relay.relay_entries.size
			#while count < @race.max_relay_size
			#	ent = RelayEntry.new
   			#	@entries << ent
   			#	count += 1
			#end
			redirect_to :action => "merchandise" unless error
		else
			@entries = @reg.av_relay_entries
		end
	end
	
	
	def merchandise
		if session[:reg_ids].nil? or session[:reg_ids].blank?
			redirect_to :action => 'athlete_info'
		end

		@event = Event.find(session[:reg_event])
		@event_registration = EventRegistration.find_by_id(session[:reg_ids].first)
		redirect_to :action => 'disclaimers' if @event.merchandise_items.empty?

		if request.post?
			params[:orders] = [] unless params[:orders]
			params[:orders].each do |moid|
				mioption = MerchandiseItemOption.find(moid.to_i)
				mioption.merchandise_orders.find( :all, :conditions => { :event_registration_id => @event_registration.id } ).each{ |o| o.delete }
				mio_order = MerchandiseOrder.new( :merchandise_item_option => mioption, 
												 :quantity => params[:quantity][moid].to_i, 
												 :event_registration => @event_registration)
				mio_order.save
			end

			if params[:quantity]
				(params[:quantity].keys - params[:orders]).each do |mid| 
					mio_orders = MerchandiseItemOption.find(mid.to_i).merchandise_orders.find( :all, :conditions => { :event_registration_id => @event_registration.id } ).each{ |o| o.delete }
				end
			end

			redirect_to :action => "disclaimers"
		end
	end
	
	
	def disclaimers
		@event = Event.find(session[:reg_event])
		@race = Race.find(session[:race] )
		@return_action = @event.merchandise_items.empty? ? "athlete_info" : 'merchandise'
		if @race.is_relay
			@return_action = "team"
		end
		if request.post?
			redirect_to :action => "payment"
		end
	end
	
	def review
		
		#not using this action anymore - redirect to payment
		redirect_to :action => "payment"
		
		#@event = Event.find(session[:reg_event])
		#@ref = session[:reg_event]
		#@race = Race.find(session[:race] )
		#@reg = EventRegistration.find(session[:e_reg])
		#
	 	#if request.post?
		#	redirect_to :action => "payment"
		#end
	end
	
	def remove_reg
	  if params[:reg_id] and session[:reg_ids].include?( params[:reg_id].to_i)
			reg_id = params[:reg_id].to_i
			session[:reg_ids].delete(reg_id) 
			current_user.event_registrations.find(reg_id).destroy
			
			if params[:from] = "athlete"
			  redirect_to :action => "athlete_info"
			elsif params[:from] = "review"
  			redirect_to :action => "review"
			end
		end	 
	end
	
	def payment
		if session[:reg_ids].nil? or session[:reg_ids].blank?
			redirect_to :action => 'athlete_info'
		end

		@reg = EventRegistration.find(session[:reg_ids].first)
		@race = Race.find(session[:race] )
		
		#get list of extra races
		@extra_races = @reg.extra_races
		@total_cost = @service_fee = @usat_fee = @entry_fee = @total_entry_fee = 0
		
		session[:reg_ids].each do |reg_id|
			ev_reg = EventRegistration.find_by_id( reg_id )
			@entry_fee += ev_reg.entry_fee( true, false )
			@total_entry_fee += ev_reg.total_cost( true, false )
			@service_fee += ev_reg.total_service_fee
			@usat_fee += ev_reg.usat_fee
			@total_cost += ev_reg.total_cost_with_service_fee.to_f
		end
		
		session[:reg_total_cost] = @total_cost
		
		#get a bad card if it's there
		@card = flash[:bad_card]
		
		#set the order of object
		if flash[:order].nil?
			#set it the first time
			@order = {}
			@order.first_name = @reg.first_name
			@order.last_name = @reg.last_name
			@order.address = @reg.address
			@order.city = @reg.city
			@order.state = @reg.state
			@order.none_us_state = @order.state unless @reg.country == "united_states"
			@order.zip = @reg.zip
			@order.country = @reg.country
		else
			address = flash[:address]
			card = flash[:order]
			
			@order = {}
			@order.first_name = card.first_name
			@order.last_name = card.last_name
			@order.address = address[:address1]
			@order.city = address[:city]
			@order.state = address[:state]
			@order.none_us_state = address[:state] unless address[:state] == "US"
			@order.country = flash[:country]
			@order.zip = address[:zip]
			@order.card_type = card.type
			@order.card_number = card.number
			@order.card_verification = card.verification_value
			
		end
		
		#prepopulate order information
		#save the registration, and set it to pending, unless the value is already completed by paypal
		unless @reg.status == "Completed"
			@reg.status = "rm_pending"
		end
		
		session[:reg_ids].each do |reg_id|
			ev_reg = EventRegistration.find_by_id( reg_id )
			ev_reg.service_fee = ev_reg.total_service_fee
  		ev_reg.cost = ev_reg.race.current_fee(ev_reg.created_at).to_f + ev_reg.usat_fee.to_f
      #if it's less than zero, set to 0
      if ev_reg.cost < 0
          ev_reg.cost = 0
      end
  		#set the IP address
  		ev_reg.ip_address = request.remote_ip
  		ev_reg.save
		end
		
		#if the total cost is 0, dont send to paypal, and set the 
		@reg.service_fee = @reg.total_service_fee
		@reg.cost = @race.current_fee(@reg.created_at).to_f + @reg.usat_fee.to_f
        #handle coupon if it's there
        @reg.cost = (@reg.cost.to_f - @reg.coupon.value.to_f) unless @reg.coupon.nil?
        #if it's less than zero, set to 0
        if @reg.cost < 0
            @reg.cost = 0
        end
		#set the IP address
		@reg.ip_address = request.remote_ip
		@reg.save 
		
		#create an event signup and associate it with the race
		es = EventSignup.find_by_event_id_and_rm_user_id(@reg.event.id, current_user.id)
		if es.nil?
			es = EventSignup.create :event => @reg.event, :rm_user => current_user, :reg_type => 2
		else
			es.reg_type = 2
			es.save
		end
		
		@reg.reload
		session[:e_reg_to_reload] = @reg.id
		@event = Event.find(session[:reg_event])
	end
	
	def success

		@reg = EventRegistration.find(params[:id])
		@reg_ids = session[:reg_ids]
		if @reg_ids.nil? or @reg_ids.empty? or !@reg_ids.include?( @reg.id )
			@reg_ids = [ @reg.id ]
		end
		@event = @reg.event


		if ((@reg.processed == false and @reg.team_id.blank? == true) or @reg.invoice_code.blank?)
			redirect_to :action => "error"
		else

			if EventSignup.find_by_event_id_and_rm_user_id(@event.id, current_user.id) == nil
	  			add_to_mrm = EventSignup.new
	      		add_to_mrm.event_id = @event.id
	      		add_to_mrm.rm_user_id = current_user.id
	      		add_to_mrm.save
			end

			@total_cost = @service_fee = @usat_fee = @entry_fee = @total_entry_fee = 0
			@reg_ids.each do |reg_id|
				ev_reg = EventRegistration.find_by_id( reg_id )
				@entry_fee += ev_reg.entry_fee( true, false )
				@total_entry_fee += ev_reg.total_cost( true, false )
				@service_fee += ev_reg.total_service_fee
				@usat_fee += ev_reg.usat_fee
				@total_cost += ev_reg.total_cost_with_service_fee.to_f

				unless ev_reg.email.blank? or ev_reg.first_name.blank?
					#RNotifier.deliver_registration_email(ev_reg.email, ev_reg.first_name.capitalize)
					#RNotifier.deliver_generic_reg_email(ev_reg)
					#RNotifier.deliver_internal_reg_audit_email(ev_reg)
				end
			end
		
			session[:e_reg_to_reload] = nil
			session[:reg_event] = nil
			session[:race] = nil
			session[:reg_ids] = []
			session[:extra] = nil
			session[:refered] = nil
			session[:reg_total_cost] = nil
		end
	end
	
	def error
    	@event = Event.find(session[:reg_event])
    	if EventSignup.find_by_event_id_and_rm_user_id(@event.id, current_user.id) == nil
  			add_to_mrm = EventSignup.new
      		add_to_mrm.event_id = @event.id
      		add_to_mrm.rm_user_id = current_user.id
      		add_to_mrm.save
        end
        session[:e_reg_to_reload] = nil
		session[:reg_event] = nil
		session[:race] = nil
		session[:reg_ids] = []
		session[:extra] = nil
		session[:refered] = nil
		session[:reg_total_cost] = nil
	end
	
	def apply_coupon
		@event = Event.find(session[:reg_event])
		if request.post?
			session[:reg_ids].each do |reg_id| # Remove existing coupon codes
				@reg = EventRegistration.find_by_id( reg_id )
				@reg.coupon = nil
				@reg.save
			end
			#do something here
			unless params[:coupon].blank?
				code = params[:coupon]["code"]
				if code.blank?
					flash[:error] = "Invalid coupon code"
				else
					coup = @event.coupons.find(:first, :conditions => ["code = ? AND expiration > ?", code, Time.now])
					if coup.blank?
						flash[:error] = "Invalid coupon code: #{code}"
					else
						#store the coupon
						session[:reg_ids].each do |reg_id|
							@reg = EventRegistration.find_by_id( reg_id )
							@reg.coupon = coup
							@reg.save
						end
						flash[:error] = "coupon code #{code} applied."
					end
						
				end
				
			end
			redirect_to :action => "payment"
		end
	end
	
	def do_process_p
		if request.post?
			@reg = EventRegistration.find(session[:e_reg_to_reload] )
			@reg.invoice_code = "NO PAYMENT"
			@reg.processed = true
	        @reg.activate_related

			@reg_ids = session[:reg_ids]
			@reg_ids.each do |reg_id|
				reg = EventRegistration.find_by_id( reg_id )
				reg.invoice_code = "NO PAYMENT"
				reg.processed = true
				reg.save
				RNotifier.deliver_generic_reg_email(reg)
				RNotifier.deliver_internal_reg_audit_email(reg)
			end
			redirect_to :action => "success", :id => @reg.id
		end
	end
	
	def create_team
		@event = Event.find(session[:reg_event])
		if request.post?
			@team = Team.create(params['team'])
			@team.event = @event
			@team.save
			unless @team.errors.empty? == false
				@result = true
  			end
		end
	end
	
	private 
	def for_activation
	 session[:return_to] = request.url
  end
	
end
