class SimpleEventsController < ApplicationController
	before_filter :login_required
	before_filter :check_valid_admin
	
  # GET /simple_events
  # GET /simple_events.xml
  def index
    #@simple_events = SimpleEvent.all
	redirect_to :action=> "new"
  end

  # GET /simple_events/1
  # GET /simple_events/1.xml
  def show
    @simple_event = SimpleEvent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @simple_event }
    end
  end

  # GET /simple_events/new
  # GET /simple_events/new.xml
  def new
    @simple_event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @simple_event }
    end
  end



  # POST /simple_events
  # POST /simple_events.xml
  def create
    @simple_event = Event.create(params[:event])
    #create a ci object
    ci = ContactInfo.create :name => @simple_event.contact_name, :phone => @simple_event.contact_phone, :email => @simple_event.contact_email
	  @simple_event.contact_info = ci
    search_types = params[:search_request]['types']
    counter = 1
    search_types.each do | et |
    	#create a race, and also add an event type
    	ev_type = EventType.find(et)
    	
    	race = Race.new :start_time => @simple_event.event_date, :event_type => ev_type, :name => ev_type.name, :event => @simple_event
    	race.race_group = @simple_event.race_groups.first
    	race.race_group_order = counter
    	counter += 1
    	#set the name, and start date according to the parent event
    	@simple_event.races << race
    	@simple_event.event_types << ev_type
    end
    #set the event to be approved
    @simple_event.approved = true
    @simple_event.manage_type = current_user.id
	if @simple_event.save
        flash[:notice] = 'event was successfully created.'
        redirect_to :action => "new"
    end    
  end


end
