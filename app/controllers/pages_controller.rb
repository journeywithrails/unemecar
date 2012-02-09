class PagesController < ApplicationController
	skip_before_filter :browser_test, :only=>[:browser, :newengland]

  
	def index
		render :layout => false
	end
	
	def feedback
		respond_to do |format|
      		format.html {
      			#not allowing html posts at this point
      			redirect_to :action => "index"
  			}
  			format.js {
  				feedback = params[:feedback]
  			    @text = feedback
  			    unless local_request?
  			    	RNotifier.deliver_feedback_email(@text)
  			    end
  			}
  		end
	end
	
	def about
	  @twitter_feed = RssParser.run("http://twitter.com/statuses/user_timeline/23487293.rss")
    
  end
  def contact
    
  end
  def advertise
    #temp - redirect to contact
    redirect_to :action => "contact"
  end
  
  def browser
  	session[:browser_ack] = true
    render :layout => false
  end
  def newengland
    render :layout => false
    @events = Event.find_by_sql("SELECT DISTINCT events.* FROM `events` join event_types_events on event_types_events.event_id=events.id WHERE (event_date > '2009-10-20' AND (state = 'MA' OR state='VT' OR state='CT' OR state='RI' OR state='NH' OR state='ME' )) ORDER BY events.event_date asc LIMIT 0, 5")
    @events = 1
  end
  
end
