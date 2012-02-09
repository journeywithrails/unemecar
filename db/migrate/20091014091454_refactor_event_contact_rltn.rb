class RefactorEventContactRltn < ActiveRecord::Migration
  def self.up
  	#add columns for rd info and contact info
  	add_column :events, :rd_contact_info_id, :integer
  	add_column :events, :contact_info_id, :integer
  	#go through all events and create contact info for them using the values we have right now
  	Event.find(:all).each do | event |
  		ci = ContactInfo.new
  		ci.name = event.contact_name
   		ci.email = event.contact_email
	    ci.phone = event.contact_phone
	    ci.state = event.contact_state
	    ci.city = event.contact_city
	    ci.zip = event.contact_zip
	    ci.address = event.contact_address
  		event.contact_info = ci
  		event.save
  	end
  	#remove the contact related fields from events
  	#remove_column :events, :contact_email
  	#remove_column :events, :contact_email
  	#remove_column :events, :contact_email
  	#remove_column :events, :contact_email
  	#remove_column :events, :contact_email
  	#remove_column :events, :contact_email
  	
  end

  def self.down
  end
end
