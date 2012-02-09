class RmUser < ActiveRecord::Base
	has_many :event_signups
	has_many :events, :through => :event_signups
	has_many :results
	has_many :result_events, :through => :results, :source => :event
	has_many :personal_bests
	has_many :event_registrations
	has_many :registered_events, :through => :event_registrations, :source => :event
	has_many :event_owners
	has_many :managed_events, :through => :event_owners, :source => :event
  #has_many :managed_teams, :through => :managed_events, :source => :event

    
	
	# Virtual attribute for the unencrypted password
  attr_accessor :password
  attr_protected :id

  validates_presence_of     :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  #validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email, :case_sensitive => false
  before_save :encrypt_password
  #after_create :register_user_to_fb
  
 

  
  def display_name
  	if (self.first_name.nil? == false and self.last_name.nil? == false)
  		self.first_name + " " + self.last_name
  	else
  		self.email
  	end
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_email(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  #password related
  def forgot_password
	@forgotten_password = true
	self.make_password_reset_code
  end
  
  def reset_password
  	update_attributes(:password_reset_code => nil)
	  @reset_password = true
  end
  
  def recently_reset_password?
	@reset_password
  end
  
  def recently_forgot_password?
	@forgotten_password
  end
  
  def after_save
   
  	RNotifier.deliver_forgot_password(self) if recently_forgot_password?
	  RNotifier.deliver_reset_password(self) if recently_reset_password?
  end
	

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
	
	attr_protected :fb_usid
	
	ICONS=["cyclist_icon.gif", "runner_icon.gif", "swimmer_icon.gif"]
	
	def profile_events(limit=5)
		events.find(:all, :limit => limit, :conditions => ['event_date > ?', 1.day.ago], :order => "events.event_date asc")
	end
	
	def profile_results(limit=5)
		result_events.find(:all, :limit => limit, :conditions => ['event_date < ?', Time.now], :order => "events.event_date desc")
	end
	

	
	def fb_user
		
	end
	
	def top_friends(all_friends_list, limit=5)
		res = Array.new
		res_extra = Array.new
		counter = 0
		all_friends_list.each do | friend |
			user = RmUser.find_by_fb_usid(friend.to_s)
			unless user.nil?
			  
			  if user.activity_level != 0
				  res << user
				  #counter = counter + 1
				  #if counter == limit
  				#	break
  				#end
			  else
			    res_extra << user
		    end
			end
		end
		unless res == []
		  unless res.length == 1
		    res.shuffle!
	    end
		  unless res_extra == []
		    if res.size < 6 and res_extra.size >3
		      unless res_extra.length == 1
    		    res_extra.shuffle!
  		      end
    		  res << res_extra[0]
    		  res << res_extra[1]
    		  res << res_extra[2]
    		  res << res_extra[3]
    		  res << res_extra[4]
              res << res_extra[5]
    	  end
	    end
		end
	  res[0..5]
	end
	
		
	def top_friends_fb_output(all_friends_list, limit=5, give="fb_id")
		res = Array.new
		counter = 0
		all_friends_list.each do | friend |
			user = RmUser.find_by_fb_usid(friend.to_s)
			unless user.nil?
				res << friend
				counter = counter + 1
				if counter == limit
					break
				end
			end
		end
		res
	end
	def top_friends_user_output(all_friends_list, limit=5, give="fb_id")
		res = Array.new
		counter = 0
		all_friends_list.each do | friend |
			user = RmUser.find_by_fb_usid(friend.to_s)
			unless user.nil?
				res << user
				counter = counter + 1
				if counter == limit
					break
				end
			end
		end
		res
	end
	
	def check_for_past_events(fbuser)
		#find event signups that are in the past, and create results for them
		cands = events.find(:all, :conditions => ['events.event_date < ?', Time.now])
		res = Array.new
		cands.each do | cand |
			es = EventSignup.find_by_event_id_and_rm_user_id(cand.id, self.id)
			#check if there's a result associated with that event. if so, dont create one
			cand_res = Result.find_by_event_id_and_rm_user_id(cand.id, self.id)
			if cand_res.nil?
				new_one = Result.create :event => cand, :rm_user => self
				res << new_one
			end
			#destroy the event signup
			es.destroy
		end
		#if this is not empty, deliver the update
		if res.size > 0
			RacePublisher.deliver_profile_update(self, fbuser)
		end
		res
	end
	
	def identification_name
	 "#{self.email}-#{self.name}-#{self.id}-#{self.login}-#{self.fb_usid}"
	end
	
	#def event_friends(all_friends, limit=5, event)
	#	res = Array.new
	#	counter = 0
	#	all_friends_list.each do | friend |
	#		user = RmUser.find_by_fb_usid(friend.to_s)
			#if user.nil? == false and (user.events.include?(event) or user.result_events.include?(event))
				#add it
			#	res << user
			#	counter = counter + 1
			#	if counter == limit
			#		break
			#	end
			#end
	#	end
	#	res
	#end
	
	
	def activity_level
	  (self.results.count + self.events.count)
  end
	
  #find the user in the database, first by the facebook user id and if that fails through the email hash
	def self.find_by_fb_user(fb_user)
	  RmUser.find_by_fb_usid(fb_user.id)
	end
	#Take the data returned from facebook and create a new user from it.
	#We don't get the email from Facebook and because a facebooker can only login through Connect we just generate a unique login name for them.
	#If you were using username to display to people you might want to get them to select one after registering through Facebook Connect
	
	def self.create_from_fb_connect(fb_user)
	  new_facebooker = RmUser.new(:name => fb_user.name, :login => "facebooker_#{fb_user.uid}", :password => "", :email => "")
	  new_facebooker.fb_usid = fb_user.uid.to_i
	  new_facebooker.first_name = fb_user.first_name
    new_facebooker.last_name = fb_user.last_name
	  #We need to save without validations
	  new_facebooker.save(false)
	  new_facebooker.register_user_to_fb
	end
	
	#We are going to connect this user object with a facebook id. But only ever one account.
	def link_fb_connect(fb_user)
	  unless fb_user.id.nil?
	    #check for existing account
	    existing_fb_user = RmUser.find_by_fb_usid(fb_user.id)
	    #unlink the existing account
	    unless existing_fb_user.nil?
	      #existing_fb_user.fb_usid = nil
	      #existing_fb_user.save(false)
	    end
	    #link the new one
	    self.fb_usid = fb_user.id
	    self.first_name = fb_user.first_name
	    self.last_name = fb_user.last_name
	    #self.name = 
	    save(false)
	  end
	end
	
	#The Facebook registers user method is going to send the users email hash and our account id to Facebook
	#We need this so Facebook can find friends on our local application even if they have not connect through connect
	#We hen use the email hash in the database to later identify a user from Facebook with a local user
	def register_user_to_fb
	  #users = {:email => email, :account_id => id}
	  #Facebooker::User.register([users])
	  #self.email_hash = Facebooker::User.hash_email(email)
	  #save(false)
	end
	
	def facebook_user?
	  return !fb_usid.nil? && fb_user_id > 0
	end
	
	def title
		"#{first_name} #{last_name}"
	end
	
	protected
	def make_password_reset_code
		self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
	end
end
