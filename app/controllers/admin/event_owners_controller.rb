class Admin::EventOwnersController < ApplicationController
	before_filter :verify_login
	
	active_scaffold :event_owner do |config|
	    config.columns = [:event_id, :rm_user_id]
	    config.columns[:event_id].form_ui = :text_field
	end
	
end
