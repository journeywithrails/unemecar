class ContactInfo < ActiveRecord::Base
	validates_presence_of :name, :email
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
	has_one :event
end
