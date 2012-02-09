class Director::SetupController < ApplicationController
	before_filter :login_required, :set_director_event
	
	def details
		@contact = @dir_event.contact_info
		if request.post?
			#process the date information
			@dir_event.event_date =  params['s_date_and_time']
			@dir_event.end_time =  params['e_date_and_time']
			#update the rest
			@dir_event.update_attributes(params['dir_event'])
			if params[:nsetting] && params[:nsetting][:_delete].to_i == 0 
			  setting = NotificationSetting.find(params[:nsetting_id]) unless params[:nsetting_id].blank?
			  setting = NotificationSetting.create(params[:nsetting]) if setting.nil?
			  setting.update_attributes(params[:nsetting])
			else
			  @dir_event.notification_setting.destroy if @dir_event.notification_setting
		  end
		  
		  unless params[:header_image].blank?
		    @dir_event.header_image.destroy unless @dir_event.header_image.nil?
		    @dir_event.header_image = Image.create(params[:header_image][0])
		    @dir_event.save
	    end
		  
			#process contact information
			if @contact.nil?
				@contact = ContactInfo.create(params[:contact])
				@dir_event.contact_info = @contact
				@dir_event.save
			else
				@contact.update_attributes(params[:contact])
			end
			
		end
		@s_date_and_time = @dir_event.event_date
		@e_date_and_time = @dir_event.end_time
	end

  def update_image
    @event = Event.find params[:evid]
    if params[:model] == 'header_image'
      @event.header_image.update_attributes({:file => params[:file_name]}) unless @event.header_image.nil?
      @event.header_image = Image.create(:file => params[:file_name]) if @event.header_image.nil?
      @event.save
      render :update do |page|
        page.replace_html params[:model], :text => "<%= image_tag @event.header_image.file(:thumb) %>"
      end
      
    elsif params[:model] =='logo'
      @event.update_attributes({:image => params[:file_name]}) 
        render :update do |page|
          page.replace_html params[:model], :text => "<%= image_tag @event.image.file(:thumb) %>"
        end
    end
    
  end
	
	def registration_text
		if request.post?
			flash[:notice] = "The registration text has been saved."
			@dir_event.update_attributes(params['dir_event']) 
		end
	end

    def order_races
        params[:sortable_races].each_with_index do |id, position|
            Race.update(id, :race_group_order => position + 1)
        end
        render :nothing => true
    end
	
	def event_disclaimer
		if request.post?
			@dir_event.update_attributes(params['dir_event']) 
		end
	end
	
	def race_vis
		
		@race = @dir_event.races.find(params[:rec])
		if params[:mode] == "show"
			flash[:notice] = "The race is now visible"
			@race.visible = true
		elsif params[:mode] == "hide"
			flash[:notice] = "The race is now hidden"
			@race.visible = false
		end
		@race.save(false)
		redirect_to :action => "races"
	end
	
	def race_reg
		
		@race = @dir_event.races.find(params[:rec])
		if params[:mode] == "open"
			flash[:notice] = "Registration is now open for #{@race.name}"
			@race.registration_open = true
		elsif params[:mode] == "close"
			flash[:notice] = "Registration is now closed for #{@race.name}"
			@race.registration_open = false
		end
		@race.save(false)
		redirect_to :action => "races"
	end
	
	def wait_list
	 @waitlists = @dir_event.waitlists
	end
	
	def race
		if params[:id].nil?
			@race_title = "Add Race"
			@s_date_and_time = @dir_event.event_date
			#@race = Race.new
		else
			@race = @dir_event.races.find(params[:id])
			@race_title = "Edit #{@race.name}"
		end
		
		if request.post?
			if params[:id].nil?
				#create a new race
				@race = @dir_event.races.build(params[:race])
				@race.start_time = params[:e_date_and_time]
				#get the top value of the order
				group = @dir_event.race_groups.find(params[:group])
				@race.race_group_order = (Race.maximum("race_group_order", :conditions => ["race_group_id = ?", group.id]) + 1)
				@race.race_group = group
				
				
			else
				#save existing race
				@race = @dir_event.races.find(params[:id])
				@race.update_attributes(params[:race])
				@race.start_time = params[:e_date_and_time]
			end
      
			#save additional attributes
			if params[:bibs] == "assign_auto"
				@race.assign_bibs = true
			else
				@race.assign_bibs = false
			end
			if params[:reg] == "reg_open"
				@race.registration_open = true
			else
				@race.registration_open = false
			end
			
			if @race.save
				flash[:notice] = "race '#{@race.name}' saved successfully."
				#check if sum of all race limits exceeds the event limit
				elimit = @race.event.races.sum('field_size')
				if elimit > @dir_event.entry_limit.to_i
					flash[:notice] += "<br/>note: the combined race field limit (#{elimit}) is larger than the event limit (#{@dir_event.entry_limit})."
				end

				unless params[:changes].blank?
					p = params[:changes]
					p.map do |key,value|
						if 'new' == key
							value.each do |rf_params|
								rf_params = rf_params.merge!({'race_id' => @race.id})
								RaceFeeChange.create(rf_params) unless (rf_params[:fee].blank? or rf_params[:change_date].blank?)  
							end
						else
							RaceFeeChange.find(key).destroy if value[:_delete].to_i == 1
							if !(!@race.event_registrations.empty? and value['change_date'] and DateTime.parse(value['change_date']) < DateTime.now)
								RaceFeeChange.find(key).update_attributes(value) if value[:_delete].to_i == 0
							end
						end
					end
				end

				redirect_to :action => "races"
			end
		end
	end

  def delete_race
  	#find the race and delete it
  	@race = @dir_event.races.find(params[:id])
  	@race.destroy
  	flash[:notice] = "race '#{@race.name}' has been deleted."
	redirect_to :action => "races"
  	
  end
  
  def start_list
  	if request.post?
  		#set all races to not show start list
  		@dir_event.races.each do | race|
  			race.show_on_start_list = false
  			race.save(false)
  		end
  		#go through the incoming races (if any) and set them to true
  		if params[:search_request].nil? == false and params[:search_request]['types'].nil? == false
  			params[:search_request]['types'].each do | et |
  				race = @dir_event.races.find(et.to_i)
  				race.show_on_start_list = true
  				race.save(false)
  			end 
  		end
  		#check if we need to display total
  		@dir_event.show_total_on_start_list = params[:show_on_total].blank? == false
  		@dir_event.save
  		@dir_event.races.reload
  	end
  end
  
  def series
  	@series = EventSeries.find_all_by_rm_user_id(current_user.id)
  end
  
  def custom_questions
    ## find all questions and update them
    if request.post? and params[:question_ids]
        @questions = Question.find params[:question_ids] 
        @questions.each do |question|
          #question.update_attributes!(params[:question][question.id.to_s]) if params[:question].has_key?(question.id.to_s)
        end
    end
    
    ## if Add new question or edit a question form
    if request.post? and params[:new_question]
      ## Check if the question is getting edit
      if params[:slug_question_id].nil? or params[:slug_question_id].empty?
        @question = @dir_event.questions.new(params[:new_question])
        @question.save
      else 
          @question = Question.find(params[:slug_question_id])
          @question.update_attributes(params[:new_question])
      end
    end  
    render :template => "director/setup/custom_questions"
  end

  def merchandise
    if request.post? || request.put?
      mi = nil
      unless params[:merchandise_item].blank?
        unless params[:merch_id].blank? 
          mi =  MerchandiseItem.find(params[:merch_id])
          mi.update_attributes params[:merchandise_item]
        else
          mi =  MerchandiseItem.new params[:merchandise_item]
          mi.save!
        end
        
        
        # Saving merchandise_item_options items

          params[:mi_attrs].map do |mid, mattr|
            if mid == 'new_records'    
              mattr.each {|ma| mi.merchandise_item_options.create(ma) }
            else
              moption = MerchandiseItemOption.find(mid.to_i) 
              moption.update_attributes(mattr)    
            end
          end
      end
    end
    
  end
  
  
  
  def delete_merch_option
    merch_option = MerchandiseItemOption.find params[:id]
    merch_option.destroy
    flash[:notice] = "MerchandiseItemOption #{merch_option.title} has been deleted"
    redirect_to :action => 'merchandise'
    
  end
  
  
  def delete_merch
    merch_item = MerchandiseItem.find(params[:id])
    merch_item.destroy
    
		flash[:notice] = "Merchadise Item #{merch_item.title} has been deleted."
		redirect_to :action => "merchandise"
  end
  
  def question_add
	  render(:update) { |page| 
		  page.replace_html "active_q_p", :partial => 'question_panel', :locals => {:question => Question.new}
		  page["active_q_p"].show
		  page["add_q_p"].hide
		  page << "rescan_values();"
	  }
  end
  
  def add_merch_option
    if params[:id]
      @merch = MerchandiseItem.find(params[:id]) 
    else @merch = MerchandiseItem.new end
    render(:update) {|page| page.insert_html :before, 'merch_option_new', 
      :partial => 'merch_option_field', :locals => {:merch => @merch }, 
      :object => @merch.merchandise_item_options.build, :layout => false}
    
  end
  
  def add_question_option
	  @question = Question.find params[:id]
	  if request.post?
		  @question.update_attributes(params[:new_question])
	  end
	  render(:update) {|page| page.insert_html :before, "question_option_new", 
		  :partial => 'question_option_fields', :layout => false }
  end
  
  def remove_question_option
    @question = Question.find params[:id]
    if request.post?
      @question.question_options.destroy(QuestionOption.find params[:option_id]) 
    end
  
    render(:update){|page| page.toggle "question_option_#{params[:option_id]}" }
	
	end
	
	def preview_map
		render :layout => false
	end
	
	def discounts
		
	end
	
	def delete_coupon
		coupon = @dir_event.coupons.find(params[:id])
		coupon.destroy
		flash[:notice] = "coupon #{coupon.code} has been deleted."
		redirect_to :action => "coupons"
	end
	
	def update_coupon
		respond_to do |format|
      		format.js {
  				#update the coupon or create it
  				if params[:id].nil?
  					#create a coupon
  					@coupon = @dir_event.coupons.build(params['coupon'])
  					@coupon.expiration = params[:e_date_and_time]
  					@coupon.save
  					@new = true
  				else
  					
  					@coupon = @dir_event.coupons.find(params[:id])
  					@coupon.update_attributes(params['coupon'])
  					@coupon.expiration = params[:e_date_and_time]
  					@coupon.save
  				end
  			}
  		end
	end
	
	def add_race_group
		#delegate to the event class
		#update the page via js
		respond_to do |format|
      		format.js {
  				@group = @dir_event.create_new_group(params[:name])
  			}
  		end
	end
	
	def update_race_group
		respond_to do |format|
      		format.js {
      			@grp = @dir_event.race_groups.find(params[:gr_id])
      			@grp.title = params[:name]
      			@grp.save
  			}
  		end
	end
	
	def delete_race_group
		respond_to do |format|
      		format.js {
      			@grp = @dir_event.race_groups.find(params[:gr_id])
      			@grp.delete
  			}
  		end
	end

  def delete_question
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to :action => 'custom_questions'
  end

end
