class PpalController < ApplicationController
  include ActiveMerchant::Billing::Integrations
  
  skip_before_filter :verify_authenticity_token 
  skip_before_filter :browser_test 
  LOGIN_ID = '2NGe493vhM'
  TRANSACTION_KEY = '2U3C4b43GHjw46xm'
  def notify     
     notify = Paypal::Notification.new(request.raw_post)
     @reg = EventRegistration.find(notify.item_id)
     if notify.acknowledge
       @reg.invoice_code = notify.transaction_id
       begin
         if notify.complete?
      	   @reg.status = notify.status
           if notify.status == 'Completed'
           	 
           	 
           	 @reg.processed = true
           	 @reg.payment_gross = notify.gross
           	 @reg.activate_related
           	 RNotifier.deliver_generic_reg_email(@reg)
			 RNotifier.deliver_internal_reg_audit_email(@reg)
           end
         else
           logger.error("Failed to verify Paypal's notification, please investigate")
         end       
       rescue => e
         @reg.status = 'Error'
         raise
       ensure
         
         @reg.save
       end
     end
     render :nothing => true   
  end
  
  def process_cc
  	if request.post?
  		order = params[:order]
	  	print ActiveMerchant::Billing::Base.mode
	  	print "\n"
	  	#get the reg 
	  	@reg = EventRegistration.find(session[:e_reg_to_reload] )
		@reg_ids = session[:reg_ids]
		if @reg_ids.nil? or @reg_ids.empty? or !@reg_ids.include?( @reg.id )
			@reg_ids = [ @reg.id ]
		end

		#ActiveMerchant::Billing::Base.mode = :test 
		charge_amount = session[:reg_total_cost].to_f * 100
		#number = '4222222222222' #Authorize.net test card, error-producing
		number = '4007000000027' #Authorize.net test card, non-error-producing
		
		#check which state do we want to use
		
		state = order["state"]
		unless order['country'] == "united_states"
		  state = order["none_us_state"]
		end
		
		country =  ActiveMerchant::Country.find(order['country'].humanize.titleize).code(:alpha2)[0].value
		billing_address = { :name => "#{order["first_name"]} #{order["last_name"]}", :address1 => order["address"],
			:city => order["city"], :state => state,
			:country => country, :zip => order["zip"], :phone => order["phone"] }
		
		credit_card = ActiveMerchant::Billing::CreditCard.new(
			:type => order["card_type"],
        	:number => order["card_number"],
      		:verification_value => order["card_verification"],
      		:month              => order["card_expires_on(2i)"],
      		:year               => order["card_expires_on(1i)"],
      		:first_name         => order["first_name"],
      		:last_name          => order["last_name"]
		)
		
		if credit_card.valid?
			gateway = ActiveMerchant::Billing::Base.gateway(:authorize_net).new(
			 :login  => '2NGe493vhM',
			 :password => '9956KxXy9M4hx4MM'#, :test => true
			)
			options = {:address => {}, :billing_address => billing_address}
			response = gateway.purchase(charge_amount, credit_card, options)
		
			if response.success?
				#authorize the reg
                time = Time.now
                fmt = time.strftime("%Y%m")
				@reg_ids.each do |reg_id|
					reg = EventRegistration.find_by_id( reg_id )
	  	
					reg.invoice_code = response.authorization
					reg.payment_notes = "#{credit_card.type} #{credit_card.display_number}"
					reg.status = "Complete"
					reg.processed = true
					reg.payment_gross = charge_amount / 100
					reg.activate_related
					reg.save
					RNotifier.deliver_generic_reg_email(reg, credit_card)
					RNotifier.deliver_internal_reg_audit_email(reg, credit_card)
				end
				#redirect
			 	redirect_to :controller => "register", :action => "success", :id => @reg.id
			else
			 	flash[:card_error] = response.message			 	
			 	redirect_to :controller => "register", :action => "payment"
		  end
		else
			flash[:bad_card] = credit_card.errors
			flash[:order] = credit_card			
			flash[:address] = billing_address
			flash[:country] = order['country']
			redirect_to :controller => "register", :action => "payment"
		end
	end
	
	
  
  end
end
