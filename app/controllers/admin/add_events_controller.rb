class Admin::AddEventsController < ApplicationController
	before_filter :verify_login
	layout "admin"
	active_scaffold :event do |config|
		config.columns << :real_id 
	    config.list.columns = [:real_id, :name, :city, :state, :event_date, :tag_line, :event_types]
	    config.create.columns = [:name, :tag_line, :approved, :manage_type, :host, :is_register_open, :event_types, :description, :event_date, :end_time, :address_info, :city, :state, :zip, :contact_info, :register_link ,:map_link, :image, :host, :benefiting, :registration_text, :disclaimer_text]
	    config.update.columns = [:name, :tag_line, :approved, :manage_type, :host, :is_register_open, :event_types, :description, :event_date, :end_time, :address_info, :city, :state, :zip, :contact_info, :register_link ,:map_link, :image, :host, :benefiting, :registration_text, :disclaimer_text]
	    
	    config.columns[:real_id].label = "DB ID"
	    config.columns[:event_date].label = "Start time"
	    config.columns[:address_info].label = "Location"
	    config.columns[:register_link].label = "Website"
	    config.columns[:is_register_open].label = "Registration Open?"
	    #config.columns[:discipline].form_ui = :select
	    config.columns[:event_types].form_ui = :select
	    config.columns[:state].form_ui = :usa_state
	    config.nested.add_link("Contact Info", [:contact_info])
	    #config.nested.add_link("Teams", [:teams])
	    #config.nested.add_link("Races", [:races])
	    #config.nested.add_link("Questions", [:questions])
	    #config.action_links.add 'ti4k_export', :label => 'Export Ti4k ',:action => 'ti4k_export', :popup => true
	    
	    
	end
	
	def conditions_for_collection
  		['approved = false AND manage_type = 1']
	end
	
	def send_appr_email
		
	end
end
