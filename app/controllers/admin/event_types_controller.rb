class Admin::EventTypesController < ApplicationController
	before_filter :verify_login
	layout "admin"
	active_scaffold :event_type do |config|
	    config.list.columns = [:name, :discipline, :distance]
	    config.create.columns = [:name, :discipline, :distance]
	    config.update.columns = [:name, :discipline, :distance]
	    config.show.columns = [:name, :discipline, :distance]
	    config.columns[:discipline].form_ui = :select
	    config.columns[:distance].label = "Distance (in kilometers)"
	end
end
