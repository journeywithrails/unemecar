class Admin::TeamEntriesController < ApplicationController
	active_scaffold :team_entry do |config|
	    #config.list.columns = [:name, :city, :state, :event_date, :tag_line, :discipline, :event_type]
	end
end

