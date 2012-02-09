# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  helper :all # include all helpers, all the time
  before_filter :set_facebook_session
  helper_method :facebook_session

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery # :secret => '8adb07763da86f7d4a88d6f140564e53'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :card_number, :card_verification
  helper_method :facebook_session
  before_filter :browser_test
  
  #alias_method :rescue_action_locally, :rescue_action_in_public
  
  private
  def browser_test
  	
    if request.env["HTTP_USER_AGENT"] and request.env["HTTP_USER_AGENT"][/MSIE 6/]=="MSIE 6" and session[:browser_ack].nil?
    #if request.env["HTTP_USER_AGENT"][/Mozilla/]=="Mozilla" and session[:browser_ack].nil?
      session[:browser_return_to] = request.url
      redirect_to :controller=> "browser" 
    else
      site_url = request.url
      unless site_url[0..15] == "http://localhost" or site_url[0..15] == "http://127.0.0.1" or site_url[0..16] == "https://localhost" or request.port > 1000
        if site_url[0..4] == "https"
          unless site_url[0..11] == "https://www."
            redirect_to "https://www." + site_url[8..site_url.length]
          end
        elsif site_url[0..4] == "http:"
          unless site_url[0..10] == "http://www."
            redirect_to "http://www." + site_url[7..site_url.length]
          end
        end
      end
    end
  end
  
  def is_facebook_session
  	true #change this into something meaningful
  end
  
  def require_ssl
  	unless defined? RM_SKIP_SSL
  		redirect_to url_for(params.merge({:protocol => 'https://'})) unless (request.ssl? or local_request?)
  	end
  end
  
  def verify_login
  	if session[:admin_logged_45].nil?
  		redirect_to :controller => "login", :action => "index"
  	end  	
  end
  
  def compute_service_fee(subtotal)
    return EventRegistration.calculate_service_fee(subtotal)
  end
  
  def set_add_event
  	@add_event = Event.find(session[:add_event]) unless session[:add_event].blank?	
  end
  
  def set_director_event

	@dir_event = Event.find(params[:evid])

  	if params[:evid].to_i == 5266 
		# Public Testing Event
  	elsif [ 4, 8, 13, 450, 2401, 6337,16017].include?( current_user.id )
		# Global directors
		# 4 => Eyal, 8 => Alain, 13 =>  Brian Dame , 450 => Aaron Katz, 6337 => SMR
		# 2401 => Weston Forsblad (dubtherunr@aol.com)
  	else
		# Actual Director Check
		unless @dir_event.owners.include?( current_user )
			redirect_to "/myracemenu/managed"
			@dir_event = nil
		end
  	end
  	
  end
  
  def check_valid_admin
	if [ 4 , 8, 881, 2401, 6337, 8819, 3414].include?( current_user.id )
		# Admins
		# 4 => Eyal, 8 => Alain, 881 => Nazim Meghani, 6337 => SMR
		# 2401 => Weston Forsblad (dubtherunr@aol.com)
  		result = "true"
  	else
  		redirect_to "/calendar"
  	end
  	
  end
  
  #custom error pages
  def render_optional_error_file(status_code)
	if status_code == :not_found
	    render_404
	else
	    super
	end
  end
  
  def render_404
    respond_to do |type| 
    	type.html { render :template => "pages/error_404", :layout => 'application', :status => 404 } 
    	type.all  { render :nothing => true, :status => 404 } 
    end
  	true  # so we can do "render_404 and return"
  end

  def log_error( exception )
	  super
	  return if exception.message =~ /^No route matches/i	# Supressing no route matches error emails
	  RNotifier.deliver_error_message( exception, clean_backtrace( exception ),
									  session.instance_variable_get("@data"), 
									   params, request.env )
  end
  
end


class Hash
 def method_missing(m, *args)
   if (m.to_s =~ /=$/)
     store(m.to_s[0..-2], *args)
   else
     self.[](m.to_s)
   end
 end
end
