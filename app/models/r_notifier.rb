class RNotifier < ActionMailer::Base

	# using ARMailer
	self.delivery_method = :activerecord
	
	def feedback_email(feedback_text)
		recipients 'help@racemenu.com'
		from  'donotreply@racemenu.com'
		subject 'feedback'
		content_type "text/html"
		# Email body substitutions go here
		body :text => feedback_text
	end  
	
	def registration_email(to_email, first_name, event)
	  #RNotifier.deliver_registration_email("patedm@gmail.com", "test")
		recipients to_email
		from  'donotreply@racemenu.com'
		subject "Registration Confirmation to #{event.name}"
		content_type "text/html"
		# Email body substitutions go here
		body :first_name => first_name, :event => event
		
	end
	
	def waitlist_email(event, race, name)
	 recipients event.notifier_emails
	 from 'donotreply@racemenu.com'
	 subject 'Waitlist confirmation'
	 content_type 'text/html'
	 body :event => event, :race => race, :name => name
	end
	
	def reg_invitation_email(invitation, link)
	 recipients invitation.email
	 from 'donotreply@racemenu.com'
	 subject "Registration Invitation for #{invitation.event.name}: #{invitation.race.try(:name)}"
	 content_type 'text/html'
	 body :link => link, :event => invitation.event  
	end
	
	def daily_event_report(event, emails)
	  recipients emails
	  from 'donotreply@racemenu.com'
	  subject "RM Daily Update: – #{Date.today}"
	  content_type 'text/html'
	  body :event => event
	end
	
	def registration_limit_email(event, races, emails)
		recipients emails
		from 'donotreply@racemenu.com'
		subject "#{event.name} entry limit exceeded"
		content_type 'text/html'
		body :event => event, :races => races
	end

	def generic_reg_email(registration, credit_card=nil)
		recipients registration.email
		from  'confirmation@racemenu.com'
		subject "Registration Confirmation - #{registration.event.name}"
		content_type "text/html"
		# Email body substitutions go here
		body :reg => registration, :event => registration.event, :card => credit_card
		
	end
	
	def add_event_email(event)
		recipients 'help@racemenu.com'
		cc 'alain@racemenu.com'
		bcc 'ekedem@gmail.com'
		from  'donotreply@racemenu.com'
		subject 'add event form submission - need to moderate'
		content_type "text/html"
		# Email body substitutions go here
		body :event => event
	end
	
	def add_event_confirmation_email(email, event)
	  if email.nil? == false
	    recipients email
	  else
	    recipients event.contact_email
	  end
	  bcc 'ekedem@gmail.com'
		from  'donotreply@racemenu.com'
		subject 'RaceMenu: Thank you for submitting your event'
		content_type "text/html"
		# Email body substitutions go here
		body :event => event
	end
	
	def cancellation_email(reg)
		recipients 'help@racemenu.com'
		cc 'alain@racemenu.com'
		bcc 'ekedem@gmail.com'
		from  'donotreply@racemenu.com'
		subject 'Cancellation - need to process refund'
		content_type "text/html"
		# Email body substitutions go here
		body :reg => reg
	end
	
	def internal_reg_audit_email(reg, credit_card=nil)
		event = reg.event

		recipients_list = [ 'racemenu.confirmation@gmail.com' ]
		if notification_setting = event.notification_setting
			if notification_setting.rec_reg_notification
				recipients_list << notification_setting.notification_email unless notification_setting.notification_email.nil? or notification_setting.notification_email.blank?
			end
		end

		recipients recipients_list
		evid = reg.event.id
		if evid == 5238 or evid == 5226 or evid == 5239
			cc 'burnett22@gmail.com'
		elsif evid == 6426
			cc 'barry.petzold@gmail.com'
		end
		bcc 'ekedem@gmail.com'
		from  'donotreply@racemenu.com'
		subject "RaceMenu Registration ##{reg.id} - #{reg.first_name} #{reg.last_name}, event ##{reg.event.id}: #{reg.event.name}"
		content_type "text/html"
		# Email body substitutions go here
		body :reg => reg, :card => credit_card
	end
	
	def forgot_password(user)
		recipients user.email
    #~ recipients "gopi.indra@gmail.com"
		from  'donotreply@racemenu.com'
		subject "Request to change your password"
		content_type "text/html"
		body :url => "http://www.racemenu.com/sessions/reset_password/#{user.password_reset_code}", :user => user
	end
	
	def reset_password(user)
		recipients user.email
		from  'donotreply@racemenu.com'
		subject "your password has been reset"
		content_type "text/html"
		body :user => user
	end

    def team_added_email(team, event_id, mode, user_email = nil)
        @event = Event.find(event_id)
        if mode == "RD_TEAM_ADD"
            recipients @event.contact_email
            from  'donotreply@racemenu.com'
            subject "Team #{team.name} has been added to #{@event.name}"
            content_type "text/html"
            body :url => "http://www.racemenu.com/director/#{@event.id}/registration/edit_team/#{team.id}", :mode => mode, :team => team
        elsif mode == "USER_TEAM_ADD"
            recipients user_email
            from  'donotreply@racemenu.com'
            subject "Team #{team.name} has been added to #{@event.name}"
            content_type "text/html"
            body :url => "http://www.racemenu.com/myracemenu/team?event=#{team.id}", :mode => mode, :team => team
        end
    end

	def error_message( exception, trace, session, params, env )
		recipients  ['sunil@racemenu.com', 'eyal@racemenu.com']
		bcc  ['sharma_nyros@yahoo.com']
		from		 'errors@racemenu.com'
		subject		 "Racemenu error : #{env['REQUEST_URI']}"
		sent_on 	 Time.now
		body :exception => exception, :trace => trace, :session => session, :params => params, :env => env
	end
end
