class Admin::EventSignupsController < ApplicationController
	before_filter :verify_login
	active_scaffold :event_signup do |config|
	    #config.list.columns = [:name, :city, :state, :event_date, :tag_line, :discipline, :event_type]
	end
end
