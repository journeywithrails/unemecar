class Director::MarketingController < ApplicationController
	before_filter :login_required, :set_director_event
end
