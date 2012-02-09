class Director::RegistrationController < ApplicationController
	require 'reports_generator'
	before_filter :login_required,:set_director_event
	
	def index
		page = params[:page]||=1
		@search_req = params[:search]
		@regs = EventRegistration.paginate_reg_records(@search_req, page, @dir_event.id, 30, params[:sort], current_user)
	end

    def cancellations
        page = params[:page]||=1
		    @sort = params[:sort]||= "created_at ASC"
		    @regs = EventRegistration.paginate(:page => page,:per_page => 30, :conditions => ["processed = false AND status = 'Trash' and event_id = ?", @dir_event.id], :order => @sort)
    end

    
  	def wait_list
  	  @waitlists = @dir_event.waitlists
  	end
  	
    def change_race_option
		  @reg = EventRegistration.find( params[:reg_id] )
  		if @event = Event.find(params[:event_id])
  			@reg = EventRegistration.new if @reg.event_id != @event.id
  			render :inline => "<% fields_for @reg do |f| %><%= f.select :race_id, @event.races.map{|race| [race.name, race.id]}, { :prompt => '-Please Select-' }  %><% end %>
  			<br/><b>Note:</b> Changing race/category may require collecting additional fees."
  		end
    end
    
    def invite_from_waiting
      wlist = Waitlist.find(params[:wlid])
      wlist.update_attributes({:is_invited => true})
      invite = Invitation.create({:email => wlist.email, :event_id => wlist.event.id, :race_id => wlist.race_id})
      RNotifier.deliver_reg_invitation_email(invite, invite.activation_link(request))
      render :update do |page|
        page.replace_html "wlist_#{wlist.id}", :partial => '/director/registration/waitlist_row', :object => wlist
      end
    end
    
    def invite_users
      @event = @dir_event
      if request.post?
        p, emails = params[:invitation], params[:invitation][:email] 
        emails = emails.split(',').map{|e| e.strip}
        logger.debug { "#{emails.inspect}" } 
        emails.each do |email| 
          @invitation = Invitation.new({:email => email, :race_id => p[:race_id], :event_id => p[:event_id]})
          if @invitation.save
            link = @invitation.activation_link(request)
            RNotifier.deliver_reg_invitation_email(@invitation, link)
          end
        end
        flash[:notice] = emails.blank? ? "Please provide email with comma.": "Invitation link has been sent to #{emails}"
      end
    end
    
    
    def discounts
        page = params[:page]||=1
		@sort = params[:sort]||= "created_at ASC"
		@regs = EventRegistration.paginate(:page => page,:per_page => 30, :conditions => ["processed = true AND coupon_id IS NOT NULL and event_id = ?", @dir_event.id], :order => @sort)
    end

    def teams
        page = params[:page]||=1
		    @sort = params[:sort]||= "created_at ASC"
		    @teams = Team.paginate(:page => page,:per_page => 30, :conditions => ["event_id = ?", @dir_event.id], :order => @sort)
    end
    
    def team_members
      @team = @dir_event.teams.find(params[:id])
    end

    def edit_team
        @team = @dir_event.teams.find(params[:id])
        if request.post?
			@team.update_attributes(params[:team])
			@team.approved = params[:team]["approved"]
			if @team.save
				redirect_to :action => "teams"
			end
		end
    end
	
	def export_reg
		if request.post?
			#generate the excel
			data = ReportsGenerator.create_reg_spreadsheet(@dir_event, params[:export_e], params[:s_date_and_time], params[:e_date_and_time])
			#send the data
			send_data(data, :type => "text/csv", :disposition => 'attachment', :filename => "#{@dir_event.name} - registration export.csv")
		end
	end
	
	def export_merch
		if request.post?
			#generate the excel
			data = ReportsGenerator.create_merch_spreadsheet(@dir_event, params[:export_e], params[:s_date_and_time], params[:e_date_and_time])
			#send the data
			send_data(data, :type => "text/csv", :disposition => 'attachment', :filename => "#{@dir_event.name} - merchandise export.csv")
		end
	end
	
	def search
		redirect_to :action => "index", :show => "search"
	end
	
	def create
		
	end

    def resend_email
        reg = @dir_event.event_registrations.find(params[:id])
        RNotifier.deliver_generic_reg_email(reg, nil)
        flash[:error] = "the registration email has been resent."
        redirect_to :action => "edit", :id => reg.id
    end

    def cancel
        reg = @dir_event.event_registrations.find(params[:id])
        unless reg.nil?
            EventRegistration.send_to_trash(reg.id)
            flash[:error] = "the registration has been canceled."
        end
        redirect_to :action => "edit", :id => reg.id
    end
	
	def edit
		if params[:mode] == "new"
			@event_registration = EventRegistration.new
			@event_registration.is_manual = true
		else
			@event_registration = @dir_event.event_registrations.find(params[:id])
		end
		if request.post?
			if params[:id].blank?
				@event_registration = @dir_event.event_registrations.build(params[:event_registration])
				#set birthday manually
				@event_registration.birthday = params["e_date_and_time"]
				#set race manually
				@event_registration.race_id = params[:event_registration]["race_id"].to_i
				#set the reg to manual
				@event_registration.is_manual = true
				#set the cost to be whatever the current cost of the race is
				@event_registration.cost = @event_registration.race.current_fee(@event_registration.created_at)
				#set to processed
				@event_registration.processed = true
				#if no errors, redirect to index
				if @event_registration.save
					redirect_to :action => "index"
				end
			else

				#handle cancel separately, validations might not need to run
				if params[:commit] == "cancel registration"
					@event_registration.update_attributes(params[:event_registration])
					EventRegistration.send_to_trash(@event_registration)
					if @event_registration.valid?
                    	flash[:error] = "the registration has been canceled."
                    end
                    #redirect_to :action => "edit", :id => @event_registration.id
                elsif params[:commit] == "undo cancel"
					EventRegistration.uncancel(@event_registration)
					if @event_registration.valid?
                    	flash[:error] = "the registration is now active."
                    end
                    #redirect_to :action => "edit", :id => @event_registration.id
				else 
					
					# Event change
					if @event_registration.event_id != params[:event_registration][:event_id].to_i
						@event_registration.event_id = params[:event_registration][:event_id].to_i

						# Add event signup entry for new event
						if EventSignup.find( :first, :conditions => { :event_id => @event_registration.event_id, :rm_user_id => @event_registration.rm_user_id } ).nil?
							EventSignup.create( :event_id => @event_registration.event_id, :rm_user_id => @event_registration.rm_user_id, :reg_type => 1 )
						end
					end

					# Race Change
					@event_registration.race_id = params[:event_registration]["race_id"].to_i

					#set birthday manually
					@event_registration.birthday = params["e_date_and_time"]

					@event_registration.update_attributes(params[:event_registration])
					@event_registration.save

					#check the commit params and handle accordingly
					if params[:commit] == "resend confirmation email"
						RNotifier.deliver_generic_reg_email(@event_registration, nil)
						flash[:error] = "the registration email has been resent."
						redirect_to :action => "edit", :id => @event_registration.id
					else
						redirect_to :action => "index"
					end

				end
			end
			
		end
	end
end
