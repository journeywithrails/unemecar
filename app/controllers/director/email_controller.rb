class Director::EmailController < ApplicationController
	before_filter :login_required, :set_director_event
	
	def index
		@email = EmailMessage.new
	end
end
