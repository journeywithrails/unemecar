class RacePublisher < Facebooker::Rails::Publisher
	def add_event_feed_template
		one_line_story_template  "{*actor*} is {*action*} {*event_name*} in {*event_location*} on {*event_date*}."
	end
	
	def add_result_feed_template
		one_line_story_template  "{*actor*} attended {*event_name*} in {*event_location*} on {*event_date*}."
	end
	
	def add_event_feed(event_signup, user)
		send_as :user_action
		from user
		data :action=>EventSignup::DATA_STR[event_signup.reg_type],
			 :event_name=>'<a href="' + url_for(:controller => "events", :action => "race_details", :id => event_signup.event.id, :only_path => false) + '">' + event_signup.event.name + '</a>',
			 :event_date=>event_signup.event.event_date.strftime("%a, %b %d"),
			 :event_location=>event_signup.event.location
	end
	
	def add_result_feed(result, user)
		send_as :user_action
		from user
		data :event_name=>'<a href="' + url_for(:controller => "events", :action => "race_details", :id => result.event.id, :only_path => false) + '">' + result.event.name + '</a>',
			 :event_date=>result.event.event_date.strftime("%a, %b %d"),
			 :event_location=>result.event.location
	end
	
	def profile_update(user, fbuser)
		send_as :profile
		recipients fbuser
		@events=user.profile_events(3)
		@results=user.profile_results(3)
		profile render(:partial=>"profile" ,:assigns=>{:events=>@events, :results=>@results})
		profile_main render(:partial=>"profile" ,:assigns=>{:events=>@events, :results=>@results})
	end   
end
