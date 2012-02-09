class DirectorRequest < ActiveRecord::Base
	belongs_to :event_type
	belongs_to :discipline
	
	validates_presence_of :name, :host, :discipline_id, :event_type_id, :event_date, :end_time, :address_info, :city, :state, :user_email, :contact_name, :contact_email
  validates_format_of :user_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of :contact_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  
  
  
 
  def validate
  	if end_time-event_date <= 0
  		errors.add(:end_time, "must be after the start time")
  	end
  end

  def convert_to_event
     e = Event.new
    e.approved = true
    e.name = self.name
    e.event_date = self.event_date
    e.host = self.host
    e.event_date = self.event_date
    e.end_time = self.end_time
    e.address_info = self.address_info
    e.city = self.city
    e.state = self.state
    e.host = self.host
    e.tag_line = self.tag_line
    e.results_link = self.results_link
    e.register_link = self.register_link
    e.map_link = self.map_link
    #create a contact info
    e.contact_name = self.contact_name
    e.contact_email = self.contact_email
    e.description = self.description
    e.start_time = self.start_time
  
    #save event
    e.save

    #set event types
    ev_type  = EventType.find(self.event_type_id)
    race = Race.new :start_time => e.event_date, :event_type => ev_type, :name => ev_type.name, :event => e, :race_group_order => 1, :race_group => e.race_groups[0]
	#set the name, and start date according to the parent event
	e.races << race
	e.event_types << ev_type

    e.save
    #delete DR
    self.destroy

  end
  
  
end
