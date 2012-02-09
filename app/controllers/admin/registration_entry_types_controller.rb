class Admin::RegistrationEntryTypesController < ApplicationController
	before_filter :verify_login
	layout "admin"
	active_scaffold :registration_entry_type do |config|
	    #config.list.columns = [:name, :city, :state, :event_date, :tag_line, :discipline, :event_type, :teams]
	    #config.nested.add_link("Teams", [:teams])
	    
	end
end
