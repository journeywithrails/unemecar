class Admin::TeamsController < ApplicationController
	before_filter :verify_login
	#layout "admin"
	active_scaffold :team do |config|
	    #config.list.columns = [:name, :city, :state, :event_date, :tag_line, :discipline, :event_type]
	end
end
