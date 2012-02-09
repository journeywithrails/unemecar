class EventController < ApplicationController
  def index
	  if params[:id]==nil
      redirect_to :controller=>"events", :action=>"calendar"
    else
      
      if params[:id].to_i > Event.last.id
        redirect_to  :controller=>"events", :action=>"calendar"
      else
        @event = Event.find(params[:id])
        if params[:id] != @event.to_param
          redirect_to :id=>@event.to_param
        else
          @event_friends = @event.order_friends_then_users(facebook_session)
          if @event.is_register_open != true
            render :action=>"show"
          else
            render :action=>"show_detailed"
          end
        end
      end

    end
    
  end
  def friends
    @event = Event.find(params[:id])
    @event_friends = @event.order_friends_then_users(facebook_session)
    #@event_friends = @event.list_friends(facebook_session)
    @fb_ses = facebook_session
    render :layout => false
  end
  
  def show_detailed
  	if params[:id].nil? 
      redirect_to :controller=>"events", :action=>"calendar"
  	else
  		@event = Event.find(params[:id])
  	end
  end

  def start_list
  	if params[:id].nil?
      	redirect_to :controller=>"events", :action=>"calendar"
  	else
  		@event = Event.find(params[:id])
        @sort = params[:sort]||= "event_registrations.created_at ASC"
        @page = params[:page]||= 1
        conds = ["event_registrations.processed = true and races.show_on_start_list = true and event_registrations.event_id = ?", @event.id]
        @regs = EventRegistration.paginate(:page => @page,:per_page => 40, :include => [ :race ],  :conditions => conds, :order => @sort)
  	end
  end
  
  def feature
  	@feature = Feature.find(params[:id])
  	clk = @feature.click_count
  	clk = 0 if clk.nil?
  	clk += 1
  	@feature.click_count = clk
  	@feature.save
  	redirect_to @feature.link
  end
  
  def redirect
    redirect_to params[:red]
  end
  
end
