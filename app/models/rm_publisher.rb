class RmPublisher < Facebooker::Rails::Publisher
	def add_event_feed_template
		one_line_story_template  "{*actor*} is {*action*} {*event_name*} in {*event_location*} on {*event_date*}."
	end
	
	def add_event_feed(event_signup, user)
		send_as :user_action
		from user
		data :action=>EventSignup::DATA_STR[event_signup.reg_type],
			 :event_name=> '<a href="http://racemenu.com/event/' +event_signup.event.to_param + '">'+  event_signup.event.name.gsub(/[^a-z1-9]+/i, ' ') +'</a>',
			 :event_name=>'<a href="' + url_for(:controller => "events", :action => "race_details", :id => event_signup.event.id, :only_path => false) + '">' + event_signup.event.name + '</a>',
			 :event_date=>event_signup.event.event_date.strftime("%a, %b %d"),
			 :event_location=>event_signup.event.location
	end	
end