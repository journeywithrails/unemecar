# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	
	

	def show_error(error_message)
		unless error_message.blank?
			'<span class="errorExplanation">' + error_message + '</span>'
		end
	end
	
	def web_button_image
		image_tag('/images/img-inner/ICON_web.png', :title => "Visit event website ",:border => 0, :mouseover => '/images/img-inner/ICON_web.png')
	end
	
	def add_button_image
		image_tag('/images/img-inner/ICON_add.png', :title => "Add to MyRaceMenu ", :border => 0, :mouseover => '/images/img-inner/ICON_add_f2.png')
	end
	
	def share_button_image
		image_tag('/images/img-inner/ICON_share.png', :title => "Share this event", :border => 0, :mouseover => '/images/img-inner/ICON_share_f2.png')
	end
	
	
	def register_button_image
		image_tag('/images/img-inner/BTN_register.png', :border => 0, :mouseover => '/images/img-inner/BTN_register_f2.png')
	end
	
	def registered_button_image
		image_tag('/images/img-inner/ICON_registered.png', :title => "You are registered", :border => 0, :mouseover => '/images/img-inner/ICON_registered_f2.png')
	end
	
	def save_button_image(submit=false)
		if submit
			image_submit_tag('/images/img-inner/BTN_save.png',  :onmouseover => "this.src='/images/img-inner/BTN_save_f2.png'", :onmouseout => "this.src='/images/img-inner/BTN_save.png'" )
		else
			image_tag('/images/img-inner/BTN_save.png', :border => 0, :mouseover => '/images/img-inner/BTN_save_f2.png')
		end
		
	end
	
	def post_button_image(submit=false)
		if submit
			image_submit_tag '/images/img-inner/BTN-postEvent.png',  :onmouseover => "this.src='/images/img-inner/BTN-postEvent_f2.png'", :onmouseout => "this.src='/images/img-inner/BTN-postEvent.png'" 
		else
			image_tag('/images/img-inner/BTN-postEvent.png', :border => 0, :mouseover => '/images/img-inner/BTN-postEvent_f2.png')
		end
		
	end
	
	def cog_button_image(submit=false)
		if submit
			image_submit_tag('/images/img-inner/ICON_edit.png',  {:border => 0, :mouseover => '/images/img-inner/ICON_edit_f2.png'})
		else
			image_tag('/images/img-inner/ICON_edit.png', :border => 0, :mouseover => '/images/img-inner/ICON_edit_f2.png')
		end
		
	end
	
	def edit_button_image(submit=false)
		if submit
			image_submit_tag('/images/img-inner/BTN_edit.png',  {:border => 0, :mouseover => '/images/img-inner/BTN_edit_f2.png'})
		else
			image_tag('/images/img-inner/BTN_edit.png', :border => 0, :mouseover => '/images/img-inner/BTN_edit_f2.png')
		end
		
	end
	
	def download_button_image(submit=false)
		if submit
			image_submit_tag('/images/img-inner/BTN_download.png',  {:border => 0, :mouseover => '/images/img-inner/BTN_download_f2.png'})
		else
			image_tag('/images/img-inner/BTN_download.png', :border => 0, :mouseover => '/images/img-inner/BTN_download_f2.png')
		end
		
	end
	
	def email_button_image(submit=false, title = "email")
		if submit
			image_submit_tag('/images/img-inner/ICON_email.png', {:border => 0, :mouseover => '/images/img-inner/ICON_email_f2.png', :name => "A"})
		else
			image_tag('/images/img-inner/ICON_email.png', :title => title, :border => 0, :mouseover => '/images/img-inner/ICON_email_f2.png')
		end
		
	end
	
	def ok_button_image(submit=false)
		if submit
			image_submit_tag('/images/img-inner/BTN_ok.png',  {:border => 0, :mouseover => '/images/img-inner/BTN_ok_f2.png'})
		else
			image_tag('/images/img-inner/BTN_ok.png', :border => 0, :mouseover => '/images/img-inner/BTN_ok_f2.png')
		end
		
	end
	
	def next_button_image(submit=false)
		if submit
			image_submit_tag('/images/img-inner/BTN_next.png',:id => "next_button", :onmouseover => "this.src='/images/img-inner/BTN_next_f2.png'", :onmouseout => "this.src='/images/img-inner/BTN_next.png'")
		else
			image_tag('/images/img-inner/BTN_next.png', :border => 0, :mouseover => '/images/img-inner/BTN_next_f2.png')
		end
	end
	
	def search_button_image(submit=false)
		if submit
			image_submit_tag('/images/img-inner/BTN_search.png',  {:border => 0, :mouseover => '/images/img-inner/BTN_search_f2.png'})
		else
			image_tag('/images/img-inner/BTN_search.png', :border => 0, :mouseover => '/images/img-inner/BTN_search_f2.png')
		end
	end
	
	def search_calendar_button_image(submit=false)
		if submit
			image_submit_tag('/images/img-inner/BTN_searchCalendar.png',  {:border => 0, :mouseover => '/images/img-inner/BTN_searchCalendar_f2.png'})
		else
			image_tag('/images/img-inner/BTN_search.png', :border => 0, :mouseover => '/images/img-inner/BTN_search_f2.png')
		end
	end
	
	def login_button_image(submit=false)
		if submit
			image_submit_tag('/images/img-inner/BTN_login.png',  {:border => 0, :mouseover => '/images/img-inner/BTN_login_f2.png'})
		else
			image_tag('/images/img-inner/BTN_login.png', :border => 0, :mouseover => '/images/img-inner/BTN_login_f2.png')
		end
	end
	
	def feedback_button_image
		image_tag('/images/img-inner/BTN_feedback.png', :border => 0, :mouseover => '/images/img-inner/BTN_feedback_f2.png')
	end
	
	def back_button_image
		image_tag('/images/img-inner/BTN_back.png', :border => 0, :mouseover => '/images/img-inner/BTN_back_f2.png')
	end
	
	def cancel_button_image
		image_tag('/images/img-inner/BTN_cancel_BIG.png', :border => 0, :mouseover => '/images/img-inner/BTN_cancel_BIG_f2.png')
	end
	
	def small_cancel_button_image
		image_tag('/images/img-inner/BTN-cancel.png', :border => 0, :mouseover => '/images/img-inner/BTN-cancel_f2.png')
	end
	
	def remove_from_mrm_button_image
		image_tag('/images/img-inner/ICON_remove_or_close.png', :title => "Remove from MyRaceMenu", :border => 0, :mouseover => '/images/img-inner/ICON_remove_or_close_f2.png')
	end
	
	def close_button_image
		image_tag('/images/img-inner/ICON_remove_or_close.png', :border => 0, :mouseover => '/images/img-inner/ICON_remove_or_close_f2.png')
	end

    def delete_button_image(title="delete")
		image_tag('/images/img-inner/ICON_remove_or_close.png', :title => title, :border => 0, :mouseover => '/images/img-inner/ICON_remove_or_close_f2.png')
	end

	def goto_button_image
		image_tag('/images/img-inner/ICON_goto.png', :border => 0, :mouseover => '/images/img-inner/ICON_goto_f2.png')
	end
	
	def add_race_button_image
		image_tag('/images/img-inner/BTN_add_races.png', :border => 0, :mouseover => '/images/img-inner/BTN_add_races_f2.png')
	end
	
	def results_button_image
		image_tag('/images/img-inner/ICON_results.png', :border => 0, :mouseover => '/images/img-inner/ICON_results_f2.png')
	end
	
	def view_mrm_image
		image_tag('/images/img-inner/BTN-viewMRM.png', :border => 0, :mouseover => '/images/img-inner/BTN-viewMRM_f2.png')
	end
			
	def addmrm_button_image(submit=false, onclick=nil)
		if submit
		  if onclick !=nil
		    image_submit_tag('/images/img-inner/BTN-addtoMRM.png',  {:border => 0, :mouseover => '/images/img-inner/BTN-addtoMRM_f2.png', :onclick=>onclick })
	    else
			  image_submit_tag('/images/img-inner/BTN-addtoMRM.png',  {:border => 0, :mouseover => '/images/img-inner/BTN-addtoMRM_f2.png'})
		  end
		else
			image_tag('/images/img-inner/BTN-addtoMRM.png', :border => 0, :mouseover => '/images/img-inner/BTN-addtoMRM_f2.png')
		end
	end
	
	def suggest_events_button_image
		image_tag('/images/img-inner/BTN_suggest_events.png', :border => 0, :mouseover => '/images/img-inner/BTN_suggest_events_f2.png')
	end	
	
	def sub_suggestion_button_image(submit=false)
		if submit
			image_submit_tag('/images/img-inner/BTN-submitSuggestion.png',  {:border => 0, :mouseover => '/images/img-inner/BTN-submitSuggestion_f2.png'})
		else
			image_tag('/images/img-inner/BTN-submitSuggestion.png', :border => 0, :mouseover => '/images/img-inner/BTN-submitSuggestion_f2.png')
		end
	end
	
	def signup_button_image(submit=false)
		if submit
			image_submit_tag('/images/img-inner/BTN_signup.png',  {:border => 0, :mouseover => '/images/img-inner/BTN_signup_f2.png'})
		else
			image_tag('/images/img-inner/BTN_signup.png', :border => 0, :mouseover => '/images/img-inner/BTN_signup_f2.png')
		end
	end
	
	def is_facebook_session
  		true #change this into something meaningful
  	end
  	
  	def age(birthday, date)
		return "" if birthday.nil? or birthday.blank?
  		date_obj = DateTime.parse(date.to_s) 
  		age = (date_obj - birthday) / 365.25 # or (1.year / 1.day)
  		age.to_i
  	end

    #only show the distance column if we have a cycling race in this event
    def show_distance_column(event)
        event.races.each do |race|
            if race.event_type.nil? == false and race.event_type.discipline.nil? == false and race.event_type.discipline.name.upcase == "CYCLING"
                return true
            end
        end
        return false
    end
  	
  	#will render text that will show tooltip on hover
  	def show_tooltip(text, tooltip)
  		res = '<a class="tooltip" href="#">' + text 
		res += '<span>' + tooltip
		res += '</span></a>'
  	end
  	
  	def accordion(titles, expanders, options = {})
	 js = %Q(window.onload = function() {
	  var titles =
	   document.getElementsByClassName(’#{titles}’);
	  var expanders =
	   document.getElementsByClassName(’#{expanders}’);
	  var myEffect =
	   new Fx.Accordion(titles, expanders,
	     #{options_for_javascript(options)});
	 };)
	 javascript_tag(js.chop!)
	end
	
	def states_collection
	  [' ','AK','AL','AR','AZ','CA','CO','CT','DC','DE','FL','GA','HI','IA','ID','IL','IN','KS','KY','LA',
		'MA','MD','ME','MI','MN','MO','MS','MT','NC','ND','NE','NH','NJ','NM','NV','NY','OH','OK','OR','PA',
		'RI','SC','SD','TN','TX','UT','VA','VT','WA','WI','WV','WY']
	end
	
	

end
