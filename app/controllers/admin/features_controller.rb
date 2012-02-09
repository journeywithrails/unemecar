class Admin::FeaturesController < ApplicationController
	before_filter :verify_login
	layout "admin"
	active_scaffold :feature do |config|
	    config.list.columns = [:name, :image, :feature_order, :link, :click_count, :visible]
	    config.create.columns = [:name, :image, :feature_order, :link, :visible]
	    config.update.columns = [:name, :image, :feature_order, :link, :visible]
	    
	end
	
end
