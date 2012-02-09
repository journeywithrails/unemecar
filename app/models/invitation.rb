class Invitation < ActiveRecord::Base
  belongs_to :event, :class_name => "Event", :foreign_key => "event_id"
  belongs_to :race, :class_name => "Race", :foreign_key => "race_id"
  validates_uniqueness_of :email, :scope => [:event_id, :race_id], :on => :create, :message => "Please check if have already invited for this race."
  before_save :make_secret
  before_create :make_secret
  
  def make_secret
    return unless self.used_at.nil?
    if self.expire_at.nil?
      self.expire_at = ENV['RAILS'] == 'development' ?  (Time.now + 6.days) : ( Time.now + 1.days ) 
      self.secret = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{self.email}--")
    end
  end
  
  def activation_link(req)
    "http://#{req.host}:#{req.port}/register/activate?activation_code=#{secret}"
  end
  
  def disable!
    ret = self.used_at.eql?(nil) and Time.now < self.expire_at 
    update_attributes({:used_at => Time.now, :secret => nil}) if ret 
    ret
  end
  
  def status
    return "Expired" if self.expire_at < Time.now
    self.used_at.nil? ? "Not used" : "Activated"
  end
  
end
