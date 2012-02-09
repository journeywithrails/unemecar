class AddEventController < ApplicationController
	before_filter :login_required
	before_filter :set_add_event
	
	def index
		#clear the session variables
		session[:add_event] = nil
		session[:name_to_check] = nil
		session[:city_to_check] = nil
		session[:state_to_check] = nil
		redirect_to :action => "name_check"
	end
	
	def acquire
		#process the hash and find the corresponding events
	end
	
	#entry into the update mode
	def do_update
		@event = Event.find(params[:id])
		#@event.approved = false
		#set the event type
		
		session[:add_event] = @event.id
		session[:edit_current] = true
		flash[:notice] = "You are now editing '#{@event.name}'."
		redirect_to :action => "date_info"
		
	end
	
	#entry into the update mode
	def continue
		@event = current_user.managed_events.find(params[:id])
		if @event.nil? == false
			session[:add_event] = @event.id
			session[:in_edit] = true
			redirect_to :action => "review"
		else
			flash[:notice] = "Error locating event."
			redirect_to :controller => "myracemenu", :action => "managed"
		end
		
	end
	
	def name_check
		session[:in_edit] = false
		if request.post?
			#store values in the session
			if @add_event.nil? == false
				@add_event.name = params[:event]['dname']
				@add_event.city = params[:event]['city']
				@add_event.state = params[:event]['state']
				@add_event.save
				session[:name_to_check] = params[:event]['dname']
				session[:city_to_check] = params[:event]['city']
				session[:state_to_check] = params[:event]['state']
			else
				session[:name_to_check] = params[:event]['dname']
				session[:city_to_check] = params[:event]['city']
				session[:state_to_check] = params[:event]['state']
			end
			redirect_to :action => "name_select"
		end
	end
	
	def name_select
		#get the values from the session, and check if there are any available events
		@event_name = session[:name_to_check]
		#event holder
		@event = Event.new
		if @add_event.nil? == false
			@event = @add_event
		end
		@event.name = session[:name_to_check]
		@event.city = session[:city_to_check]
		@event.state = session[:state_to_check]
		@candidates = Event.lookup_similar_events(session[:name_to_check], session[:city_to_check], session[:state_to_check])
		if request.post?
			#save the event, continue in the flow
			#assign the user
			@event.approved = false
			@event.owners <<  current_user unless @event.owners.include?(current_user)
			#set the event type
			
			@event.save(false)
			@event.reload
			session[:add_event] = @event.id
			redirect_to :action => "date_info"
		end
	end
	
	def date_info
		
		@s_date_and_time = @add_event.event_date
		@e_date_and_time = @add_event.end_time
		if request.post?
			#store values in the session
			@add_event.event_date = params[:s_date_and_time]
			@add_event.end_time = params[:e_date_and_time]
			if @add_event.event_date.nil?
			  flash[:notice] = "please select a start time"
			else
			  @add_event.save
			  redirect_to :action => "location"
			end
		end
	end
	
	def location
		#event holder
		@dir_event = @add_event
		
		if request.post?
			#store values in the session
			@add_event.update_attributes(params[:dir_event])
			redirect_to :action => "event_details"
		end
	end
	
	def event_details
		@dir_event = @add_event
		if request.post?
			@add_event.update_attributes(params[:dir_event])
			redirect_to :action => "sport_details"
		end
	end
	
	def sport_details
		#@race = @add_event.races[0] unless (@add_event.races.size < 1)
		@races = @add_event.races
		#if first time, set the race start time to be the same as the event
		if @race.nil?
			@race = Race.new
			@race.start_time = @add_event.event_date
		end
		#end
		if request.post?
			#delete all races from event
			@add_event.races.clear
			@add_event.event_types.clear
			counter = 1
			unless params[:search_request].blank?
				search_types = params[:search_request]['types'] 
				search_types.each do | et |
			    	#create a race, and also add an event type
			    	ev_type = EventType.find(et)
			    	race = Race.new :start_time => @add_event.event_date, :event_type => ev_type, :name => ev_type.name, :event => @add_event, :race_group_order => counter, :race_group => @add_event.race_groups[0]
			    	#set the name, and start date according to the parent event
			    	@add_event.races << race
			    	@add_event.event_types << ev_type
			    	counter += 1
			    end
			end
		    if counter == 1 #no race
		    	flash[:error] = "you must select at least one sport type"
		    else
		    	redirect_to :action => "contact_information"
		    end
			
		end
	end
	
	def contact_information
		@dir_event = @add_event
		@contact = @dir_event.contact_info
		if request.post?
			if @contact.nil?
				@contact = ContactInfo.create(params[:contact])
				@dir_event.contact_info = @contact
				@dir_event.save
			else
				@contact.update_attributes(params[:contact])
			end
			if @contact.valid?
				redirect_to :action => "review"
			end
		end
	end
	
	def review
		@event = @add_event
		if session[:in_edit] == true
			@title = "Edit your Event"
			@htitle = "Edit your Event"			
		else
			@title = "Review your Event"
			@htitle = "Create a New Event - Review your Event"		
		end
		if request.post?
			if session[:edit_current]
				#set event ownership
				@add_event.owners <<  current_user if @add_event.owners.include?(current_user)
				
			end
			#set the event type
			@add_event.manage_type = Event::BASIC
			@add_event.save
			#clear the session object
			session[:add_event] = nil
			session[:name_to_check] = nil
			session[:city_to_check] = nil
			session[:state_to_check] = nil
			
			#deliver the notification email if the event has been approved
			if session[:in_edit] == true
				flash[:notice] = "The event has been updated."
				session[:in_edit] = nil
			else
				RNotifier.deliver_add_event_email(@event)
				RNotifier.deliver_add_event_confirmation_email(current_user.email, @event)
				#deliver the notification email to the user
				flash[:notice] = "The event has been updated. You can now manage the event from this page."
			end
			
			
			redirect_to :controller => "myracemenu", :action => "managed"
		end
	end
	
	
end
