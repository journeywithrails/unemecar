class Admin::LoginController < ApplicationController
	skip_before_filter :verify_login
	
	def index
		render :layout=>false
	end
	
	def authenticate
		res = (params[:username] == "admin" and  params[:password] == "facebook69")
		if res == true
			session[:admin_logged_45] = "true"
			uri = params["redirect"]
			unless uri.blank? 
				redirect_to uri
			else
				redirect_to :controller => "active_events"	
			end
				
		else
			flash[:login_error] = "login error"
			redirect_to :action => "index", :redirect => uri
		end
		
		
	end
	
	def out
		session[:admin_logged_45] = nil
		redirect_to :action => "index"
	end
end
