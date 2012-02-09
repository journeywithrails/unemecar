class Waitlist < ActiveRecord::Base
  belongs_to :race, :class_name => "Race", :foreign_key => "race_id"
  belongs_to :event, :class_name => "Event", :foreign_key => "event_id"
  belongs_to :rm_user, :class_name => "RmUser", :foreign_key => "rm_user_id"
  
end
