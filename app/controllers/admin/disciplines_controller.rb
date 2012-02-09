class Admin::DisciplinesController < ApplicationController
	before_filter :verify_login
	active_scaffold :discipline do |config|
	    #config.list.columns = [:name, :city, :state, :event_date, :tag_line, :discipline, :event_type]
	end
end
