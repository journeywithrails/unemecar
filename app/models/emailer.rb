class Emailer < ActionMailer::Base
  
  def forgot_password(user)
    
  @subject            = "Request to change your password"
  
  @recipients       = 'gopi.indra@gmail.com'
  @from               = 'donotreply@racemenu.com'
   @content_type = "text/html"
    @url = "http://www.racemenu.com/sessions/reset_password/#{user.password_reset_code}"
    
    
    	#~ recipients 'gopi.indra@gmail.com'
    #recipients "gopi.indra@gmail.com"
		#~ from  'donotreply@racemenu.com'
		#~ subject "Request to change your password"
		#~ content_type "text/html"
		#~ body :url => "http://www.racemenu.com/sessions/reset_password/#{user.password_reset_code}", :user => user
  end

end
