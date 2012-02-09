class MyracemenuController < ApplicationController
	before_filter :login_required
	
	def index
	  if current_user == RmUser.find_by_fb_usid(params[:racer].to_i)
	    redirect_to :controller=>"myracemenu"
	  end
	  
		page = params[:page]
		page ||= 1
	#	@upcoming_events = Event.paginate_event_records(@search_req, page, false, 4)
	#	@result_events = Event.paginate_event_records(@search_req, page, false, 4)
		if params[:racer].blank?
		  @active_user = current_user
		  @top_param = "myracemenu"
		  if (!facebook_session.nil?)
	      @friends = @active_user.top_friends(facebook_session.user.friends, 5)
	      end
	  else
		  unless @active_user = RmUser.find_by_fb_usid(params[:racer].to_i)
		    @active_user = current_user
        redirect_to :controller=>"myracemenu"
	    else
	      #this should show the friend's friends
	      unless current_user.fb_usid == nil
	    	@active_user.top_friends_fb_output(facebook_session.user.friends, 99999).each{ |friend|
	    	  #puts "test" + friend.to_i.to_s
	    	  if friend.to_i.to_s == params[:racer]
	    	    @friends =  @active_user.top_friends(friend.friends, 5)
    	    end
	    	}
	    	@top_param = "myracemenu_active"
    	  end
	    	
	    	#puts @active_user.top_friends_fb_output(facebook_session.user.friends, 6).first.friends.first.to_i
	    	#@friends =  @active_user.top_friends(facebook_session.user.friends[0].friends, 6)
	    	#@friends = @active_user.top_friends(facebook_session.user.friends, 6)
      end
	  end
		@upcoming_events = @active_user.events.find(:all, :limit => 100, :conditions => ['event_date > ?', 1.day.ago], :order => "events.event_date asc")
	  @result_events = @active_user.result_events.find(:all, :limit => 100, :conditions => ['event_date < ?', Time.now], :order => "events.event_date desc")

#puts "testing2"
#puts facebook_session.user.friends.index(facebook_session.user.new(params[:racer]))

	end
	
	def reg_details
		@reg = EventRegistration.find(params[:reg_id])
		if request.post? 
			@reg.update_attributes(params[:reg])
			render :update do |page|
				page.replace "reg_details_#{@reg.id}",  :partial => 'events/reg_details', :object => @reg
			end
		else
		  render :update do |page|
			page.replace_html "edit_reg_#{@reg.id}_details", :partial => 'events/reg_details_edit', :object => @reg 
			page.hide "reg_details_#{@reg.id}_details"
			page.show "edit_reg_#{@reg.id}_details"
		  end
	  end
	end
	
	def managed
		@active_user = current_user
		@upcoming_events = @active_user.managed_events.find(:all, :limit => 100, :order => "events.event_date asc")
	end

    def team
        @active_user = current_user
        evt = params[:event].to_i
        @team = Team.find_by_event_id_and_race_director_id(evt, current_user.id)
        @team_entries = @team.team_entries
    end
    
    def edit_team_entry
    	@active_user = current_user
        @team = Team.find_by_id_and_race_director_id(params[:team], current_user.id)
        @entry = @team.team_entries.find(params[:id])
        @reg = @entry.event_registration
        if request.post?
    		@entry.update_attributes(params['entry'])
    		@reg.update_attributes(params['event_registration'])
    		if @reg.valid? and @entry.valid?
    			flash[:error] = "Entry '#{@entry.name}' saved successfully."
    		end   	
        end
    end

    def team_order
        @active_user = current_user
        evt = params[:event].to_i
        @team = Team.find_by_event_id_and_race_director_id(evt, current_user.id)
        @team_entries = @team.team_entries.find(:all, :order => "team_order ASC")
    end
    
    def reorder_team
        params[:sortable_entries].each_with_index do |id, position|
            TeamEntry.update(id, :team_order => position + 1)
        end
        render :nothing => true
    end

	def profile
		if request.post?
			@active_user = current_user
			@active_user.update_attributes(params['user'])
			unless current_user.fb_usid.blank?
				@friends = @active_user.top_friends(facebook_session.user.friends, 5)
			end
			#set the icon num attribute manually
			@active_user.save(false)
			#unless @active_user.errors.empty? == false
				flash[:notice] = "your settings have been saved."
				redirect_to :action => "index", :saved => "yes"
  			#end
  		else
  			@active_user = current_user
  			@user = current_user
  			unless current_user.fb_usid.blank?
  			  @friends = current_user.top_friends(facebook_session.user.friends, 5)
			  end
  		end
	end


	
	def buddies
	  if current_user == RmUser.find_by_fb_usid(params[:racer].to_i)
	  	  redirect_to :controller=>"myracemenu", :action=>"buddies"
	  
	  elsif (!facebook_session.nil?)
	  	  if params[:racer].blank?
		  	  @active_user = current_user
		      @friends = @active_user.top_friends_user_output(facebook_session.user.friends, 99999)
		      @top_param = "myracemenu"
	      else
	      	  @active_user = RmUser.find_by_fb_usid(params[:racer].to_i)
	      	  @active_user.top_friends_fb_output(facebook_session.user.friends, 99999).each{ |friend|
	      	  	  if friend.to_i.to_s == params[:racer]
	    	    	  @friends =  @active_user.top_friends_user_output(friend.friends, 99999)
    	    	  end
	    	  }
	    	  @top_param = "myracemenu_active"
	    	  if @friends == nil
	    	  	redirect_to :controller=>"myracemenu", :action=>"buddies"
    	  	  end
	      end
	   else
	     redirect_to :action => "index"
	   end
	end
end
