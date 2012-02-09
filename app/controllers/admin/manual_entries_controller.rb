class Admin::ManualEntriesController < ApplicationController
	before_filter :verify_login
	layout "admin"
	active_scaffold :event do |config|
	    config.list.columns = [:name, :city, :state, :event_date, :tag_line, :event_types]
	    config.create.columns = [:name, :tag_line, :approved, :host, :is_register_open, :event_types, :description, :event_date, :end_time, :address_info, :city, :state, :zip, :contact_name, :contact_email, :contact_phone,:register_link ,:map_link, :image, :host, :benefiting, :registration_text, :disclaimer_text]
	    config.update.columns = [:name, :tag_line, :approved, :host, :is_register_open, :event_types, :description, :event_date, :end_time, :address_info, :city, :state, :zip, :contact_name, :contact_email, :contact_phone, :register_link ,:map_link, :image, :host, :benefiting, :registration_text, :disclaimer_text]
	    
	    config.columns[:event_date].label = "Start time"
	    config.columns[:address_info].label = "Location"
	    config.columns[:register_link].label = "Website"
	    config.columns[:is_register_open].label = "Registration Open?"
	    #config.columns[:discipline].form_ui = :select
	    config.columns[:event_types].form_ui = :select
	    config.columns[:state].form_ui = :usa_state
	    #config.nested.add_link("Teams", [:teams])
	    #config.nested.add_link("Races", [:races])
	    #config.nested.add_link("Questions", [:questions])
	    #config.action_links.add 'ti4k_export', :label => 'Export Ti4k ',:action => 'ti4k_export', :popup => true
	    
	    
	end
	
	def conditions_for_collection
  		['manage_type = 881']
	end
end
