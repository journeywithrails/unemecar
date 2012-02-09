class EventsController < ApplicationController
	def index
	  if params[:id] == "calendar"
	    redirect_to :action=>"calendar"
    elsif params[:id]==nil
      redirect_to :action=>"calendar"
    else
      
      if params[:id].to_i > Event.count
        redirect_to :action=>"calendar"
      else
        @event = Event.find(params[:id])
        if params[:id] != @event.to_param
          redirect_to :id=>@event.to_param
        else
          render :action=>"show"
        end
      end

    end
    
  end
  def test
    #@test = Event.find(764).list_friends(facebook_session)
    @test = Event.find(764).order_friends_then_users(facebook_session)

  end

  
	def calendar
		@search_req = params[:search_request]
	
		#clean up the search request - abstract this out to model later
		unless @search_req.nil?
			@search_req["city"] = "" unless @search_req["city"] != "City"
			@search_req["from"] = "" unless @search_req["from"] != "From:"
			@search_req["to"] = "" unless @search_req["to"] != "To:"
			@search_req["name"] = "" unless @search_req["name"] != "Race Name"
			
			@state = @search_req['state']
		end
		page = params[:page]
		page ||= 1
		@events = Event.paginate_event_records(@search_req, page, false, 22, params[:sort])
		#reset the search req values
		if @search_req.nil?
			@search_req = Hash.new
			@search_req["city"] = "City"
			@search_req["from"] = "From:"
			@search_req["to"] = "To:"
			@search_req["rad_state"] = "State"
			@search_req["name"] = "Race Name"
			@search_req["zipcode"] = "Zip"
			@search_req["radius"] = "radius"
			@search_req["distance_display"] = "Distance"
		else
			@search_req["city"] = "City" unless @search_req["city"] != ""
			@search_req["from"] = "From:" unless @search_req["from"] != ""
			@search_req["to"] = "To:" unless @search_req["to"] != ""
			@search_req["name"] = "Race Name" unless @search_req["name"] != ""
		end
		
	end
	
	def add_race_to_mrm
		respond_to do |format|
      		format.html {
      			#not allowing html posts at this point
      			redirect_to :action => "calendar"
  			}
  			format.js {
  				@event = Event.find(params[:id])
				#check if the user has a signup already 
				es = EventSignup.find_by_event_id_and_rm_user_id(params[:id], current_user.id)
				if es.nil?
					es = EventSignup.create :event => @event, :rm_user => current_user, :reg_type => params[:add_req]['reg_type']
				else
					es.reg_type = params[:add_req]['reg_type']
					es.save
				end
				if params[:adds_req].nil? == false and params[:adds_req]['add'].blank? == false and params[:adds_req]['add'] == "1"
					#RmPublisher.deliver_add_event_feed(es, facebook_session.user)
				end
				#RacePublisher.deliver_profile_update(active_user, facebook_session.user)
  			}
  		end
		
		
	end
	
	def add_result_to_mrm
		respond_to do |format|
      		format.html {
      			#not allowing html posts at this point
      			redirect_to :action => "calendar"
  			}
  			format.js {
  				@event = Event.find(params[:id])
				@res = Result.find_by_event_id_and_rm_user_id(params[:id], current_user.id)
				if @res.nil?
					@res = Result.create(params['req'])
					@res.event = @event
					@res.rm_user = current_user
					@res.save
				else
					@res.update_attributes(params['req']) 
				end
				if params[:adds_req].nil? == false and params[:adds_req]['add'].blank? == false and params[:adds_req]['add'] == "1"
					#RacePublisher.deliver_add_result_feed(@res, facebook_session.user)
				end
				#RacePublisher.deliver_profile_update(active_user, facebook_session.user)
	  		}
	  	end
		
		
	end
	
	def remove_event
		respond_to do |format|
      		format.html {
      			#not allowing html posts at this point
      			redirect_to :action => "calendar"
  			}
  			format.js {
  				@event = Event.find(params[:id])
				#check if the user has a signup already 
				es = EventSignup.find_by_event_id_and_rm_user_id(params[:id], current_user.id)
				unless es.nil?
					es.destroy
				end
  			}
  		end
	end
	
	
end
