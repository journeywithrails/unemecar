class Admin::RedirectsController < ApplicationController
  before_filter :verify_login
	layout "admin"
	active_scaffold :redirect do |config|
	    config.columns = [:text, :url]
	    #config.columns[:event_type].form_ui = :select
	end
end
