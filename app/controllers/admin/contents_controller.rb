class Admin::ContentsController < ApplicationController
  before_filter :verify_login
	layout "admin"
	active_scaffold :content do |config|
	    config.label = "Content"
      config.actions.exclude :create
      config.list.columns = [:name]

	end
end
