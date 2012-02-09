
class EventOwner < ActiveRecord::Base

  belongs_to :event, :class_name => "Event", :foreign_key => "event_id"
  belongs_to :owner, :class_name => "RmUser", :foreign_key => "rm_user_id"

  validates_uniqueness_of :rm_user_id, :scope => :event_id, :message => 'Is already a owner for this event'

end
