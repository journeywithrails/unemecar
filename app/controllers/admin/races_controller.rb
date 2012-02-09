class Admin::RacesController < ApplicationController
	before_filter :verify_login
	#layout "admin"
	active_scaffold :race do |config|
	    config.columns = [:name, :event_type, :initial_fee, :start_time, :distance, :distance_unit, :prizes, :field_size, :registration_open]
	    config.columns[:event_type].form_ui = :select
	end
end
