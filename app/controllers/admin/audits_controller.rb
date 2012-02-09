class Admin::AuditsController < ApplicationController
    before_filter :verify_login
	layout "admin"
	active_scaffold :audit do |config|
	    #config.list.columns = [:name, :image, :feature_order, :link, :click_count, :visible]
	    #config.create.columns = [:name, :image, :feature_order, :link, :visible]
	    #config.update.columns = [:name, :image, :feature_order, :link, :visible]
        config.columns.exclude :created_at
        config.actions.exclude :create, :update
	end
end
