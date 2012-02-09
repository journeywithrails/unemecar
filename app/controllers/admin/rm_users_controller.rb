class Admin::RmUsersController < ApplicationController
	layout "admin"
	before_filter :verify_login
	active_scaffold :rm_user do |config|
	    config.list.columns = [:first_name, :last_name, :fb_usid]
	end

	def autocomplete_search
		@users = []
		if params[:owner][:name]
			q = "%#{params[:owner][:name]}%"
			@users = RmUser.find( :all, :conditions => ['first_name like ? or last_name like ? or email like ? or fb_usid like ?',q,q,q,q], :order => 'email,name' )
		end
		render :inline =>  "<%= model_auto_completer_result @users, 'identification_name' %>" 

	end
	
end
