class Admin::ActiveEventsController < ApplicationController
    before_filter :verify_login
	  layout "admin"
	
	active_scaffold :event do |config|
		config.columns << :real_id 
	    config.list.columns = [:real_id, :name, :city, :state, :event_date, :tag_line, :event_types]
	    config.create.columns = [:real_id, :name, :tag_line, :approved, :host, :is_register_open, :event_types, :description, :event_date, :end_time, :address_info, :city, :state, :zip, :contact_info, :register_link ,:map_link, :image, :host, :benefiting, :registration_text, :disclaimer_text]
	    config.update.columns = [:real_id, :name, :tag_line, :approved, :host, :is_register_open, :event_types, :description, :event_date, :end_time, :address_info, :city, :state, :zip, :contact_info, :register_link ,:map_link, :image, :host, :benefiting, :registration_text, :disclaimer_text]
		
	    config.columns[:real_id].label = "DB ID"
	    config.columns[:event_date].label = "Start time"
	    config.columns[:address_info].label = "Location"
	    config.columns[:register_link].label = "Website"
	    config.columns[:is_register_open].label = "Registration Open?"

	    config.columns[:event_types].form_ui = :select
	    config.columns[:state].form_ui = :usa_state
		
	    config.nested.add_link("Owners", [:event_owners])
      	config.nested.add_link("Teams", [:teams])
	    config.nested.add_link("Races", [:races])
	    config.nested.add_link("Questions", [:questions])
      	config.nested.add_link("Payments", [:event_payments])
        
      config.action_links.add 'rd', :label => 'RD ',:action => 'popup_rd', :popup => true, :type => :record
      config.action_links.add 'event', :label => 'Event ',:action => 'popup_event', :popup => true, :type => :record
        
      config.label = "Powered by RM"
	end

	def conditions_for_collection
  		['manage_type = 2']
	end

    def popup_event
        redirect_to "/event/show_detailed/#{params[:id]}"
    end

    def popup_rd
        redirect_to "/director/#{params[:id]}/summary"
    end
end
