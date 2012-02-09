class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  before_filter :require_ssl
  before_filter :login_required, :only => [:change_password]
   auto_complete_for :rm_user, :id
  
  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
  end

  def login
    return unless request.post?
    self.current_user = RmUser.authenticate(params[:username], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/myracemenu', :action => 'index')
      flash[:notice] = "Logged in successfully"
    else
      flash[:notice] = "Email and password do not match"
    end
  end

  def signup
    @user = RmUser.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    redirect_back_or_default(:controller => '/myracemenu', :action => 'index')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(calendar_path)
    puts "-----------------------------------------logout()"
  end
  
  def forgot_password
	return unless request.post?
	if @user = RmUser.find_by_email(params[:email])
		@user.forgot_password
		@user.save
     #~ Emailer.deliver_forgot_password(@user) 
		redirect_back_or_default(:controller => "sessions", :action => "login")
		flash[:notice] = "We have received your request and will email you a one-time link to reset your password. 
		  Please wait at least 10 minutes for the email to arrive before using this form again"
	else
		flash[:notice] = "Could not find a user with that email address"
	end
  end
  
  def reset_password
    password_reset_code = request.post? ? params[:password_reset_code] : params[:id]
    return if password_reset_code.blank?
    if @user = RmUser.find_by_password_reset_code(password_reset_code)
      self.current_user = @user
      redirect_to(:action => 'change_password')
    else
      logger.error "Invalid Password Reset Code entered." 
      flash[:notice] = "Invalid Password Reset Code entered. Please check your Code and try again." 
    end
  end

  def change_password
    return unless request.post?
    if (params[:password] == params[:password_confirmation])
      current_user.password_confirmation = params[:password_confirmation]
      current_user.password = params[:password]
      current_user.reset_password
      flash[:notice] = current_user.save ? "Password reset" : "Password not reset" 
      redirect_back_or_default(:controller => '/myracemenu')
    else
      flash[:notice] = "Password mismatch" 
    end  
  end
  
  def link_user_accounts
  	
  	puts "-----------------------------------------entering link_user_accounts"
  	if self.current_user.nil?
    	#register with fb
    	RmUser.create_from_fb_connect(facebook_session.user) unless facebook_session.nil?
    	puts "-----------------------------------------link_user_accounts create_from_fb_connect"
  	else
    	#connect accounts
    	#self.current_user.link_fb_connect(facebook_session.user.id) unless self.current_user.fb_usid == facebook_session.user.id
    	puts "-----------------------------------------link_user_accounts link_fb_connect"
  	end
  	#in any case, set the name of the current user to the facebook user
  	unless facebook_session.nil?
  		if current_user.first_name.blank?
  			current_user.first_name = facebook_session.user.first_name
  			current_user.save(false)
  		end
  		if current_user.last_name.blank?
  			current_user.last_name = facebook_session.user.last_name
  			current_user.save(false)
  		end
  	end  	
  	redirect_back_or_default('/myracemenu')
  end
end
