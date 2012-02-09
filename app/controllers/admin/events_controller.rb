require 'fastercsv'
class Admin::EventsController < ApplicationController
	before_filter :verify_login, :except=>"ti4k_export"
	layout "admin"
	active_scaffold :event do |config|
		config.columns << :real_id 
	    config.list.columns = [:real_id, :name, :city, :state, :event_date, :manage_type]
	    config.create.columns = [:name, :tag_line, :approved, :manage_type, :host, :is_register_open, :event_types, :description, :event_date, :end_time, :address_info, :city, :state, :zip, :contact_info, :register_link ,:map_link, :image, :host, :benefiting, :registration_text, :disclaimer_text]
	    config.update.columns = [:name, :tag_line, :approved, :manage_type, :host, :is_register_open, :event_types, :description, :event_date, :end_time, :address_info, :city, :state, :zip, :contact_info, :register_link ,:map_link, :image, :host, :benefiting, :registration_text, :disclaimer_text]
	    #config.columns[:manage_type].label = "M"
	    config.columns[:real_id].label = "DB ID"
	    config.columns[:event_date].label = "Start time"
	    config.columns[:address_info].label = "Location"
	    config.columns[:register_link].label = "Website"
	    config.columns[:is_register_open].label = "Registration Open?"
	    #config.columns[:discipline].form_ui = :select
	    config.columns[:event_types].form_ui = :select
	    config.columns[:state].form_ui = :usa_state
	    config.nested.add_link("Owners", [:event_owners])
	    config.nested.add_link("Teams", [:teams])
	    config.nested.add_link("Races", [:races])
	    config.nested.add_link("Questions", [:questions])
      config.nested.add_link("Payments", [:event_payments])
	    config.action_links.add 'ti4k_export', :label => 'Export Ti4k ',:action => 'ti4k_export', :popup => true
	    
	    
	end
	
	def	ti4k_export
		@users = EventRegistration.find(:all, :conditions => ["event_id = 4611 AND processed = true"], :order => "created_at ASC")
  		@outfile = "registration_ti4k_" + Time.now.strftime("%m-%d-%Y") + ".csv"
  		  
		csv_data = FasterCSV.generate do |csv|
		    csv << [
		    "First Name",
		    "Last Name",
		    
		    "Email",
		    "Sex",
		    "Birthday",
		    "Age on 9/17/2009",
		    "Address",
		    "City",
		    "State",
		    "Zip Code",
		    
		    "Phone",
		    "T Shirt Size",
		    "Registration Type",
		    "Team",
		    "Timestamp",
		    "Contact Name",
		    "Contact Phone",
		    "Contact Relationship"
		    
		]
		@users.each do |user|
			  team = user.team.blank? ? "" : user.team.name
		      csv << [
		      user.first_name,
		      user.last_name,
		      
		      user.email,
		      user.sex,
		      user.birthday,
		      "",
		      user.address + " " + user.apt,
		      user.city,
		      user.state,
		      user.zip.to_s,
		      user.phone,
		      user.tshirt,
		      user.registration_entry_type.name,
		      team,
		    
		      user.created_at,
		      user.em_con_name,
		      user.em_con_phone,
		      user.em_con_relationship
		      ]
		    end
		  end
		
		  send_data csv_data,
		    :type => 'text/csv; charset=iso-8859-1; header=present',
		    :disposition => "attachment; filename=#{@outfile}"
		    end
end
