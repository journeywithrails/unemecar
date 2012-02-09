module Director::SetupHelper
	#look for past events that belong to the same user, and put them in a hash.
	#also put the facebook info if the user has facebook.
	def contacts_for_select(event_id)
		
	end
	
	#look for past events that belong to the same user, and put them in a hash.
	def general_info_for_select
		
	end

  def popup_link tfield, container
     update_page {|page|
      page.call "updateRTField", tfield, container
    }
     
  end
  
end
