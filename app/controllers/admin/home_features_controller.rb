class Admin::HomeFeaturesController < ApplicationController
    before_filter :verify_login
	layout "admin"
	active_scaffold :home_feature do |config|
	    config.list.columns = [:name, :image, :feature_order, :link]
	    config.create.columns = [:name, :image, :feature_order, :link, :location, :time]
	    config.update.columns = [:name, :image, :feature_order, :link, :location, :time]

	end
end
