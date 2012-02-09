class Director::SummaryController < ApplicationController
	before_filter :login_required, :set_director_event
	
	def index
        if params[:activity].nil?
        	#need to handle the cancellations parts differently
            @cancel_conds = ["processed = false and status = 'Trash'"]
            @cancel_costs = @dir_event.event_registrations.sum('cost', :conditions => @cancel_conds)
            @cancel_refunds = @dir_event.event_registrations.sum('refund_amount', :conditions => @cancel_conds)
            @cancel_net = @cancel_costs - @cancel_refunds
            @reg_conds = ['processed = true']
            @pay_conds = []
            #get discounts value
            @num_discounts = @dir_event.event_registrations.find(:all, :conditions => ["processed = true and coupon_id IS NOT NULL"]).size
            @disc_val = 0
            @dir_event.event_registrations.find(:all, :conditions => ["processed = true and coupon_id IS NOT NULL"]).each do | reg |
            	@disc_val += (reg.race.current_fee(reg.created_at).to_f - reg.cost.to_f)
                #@disc_val += reg.coupon.value
            end
            @orders = @dir_event.orders_by_time
        else
            #get the params activity
            act = params[:activity]
            end_time = DateTime.now
            start_time =  end_time - 1 if act == "day"
            start_time =  end_time - 7 if act == "week"
            start_time =  end_time - 30 if act == "month"
            @cancel_conds = ["processed = false and status = 'Trash' and created_at > ? and  created_at < ?", start_time, end_time]
            @cancel_costs = @dir_event.event_registrations.sum('cost', :conditions => @cancel_conds)
            @cancel_refunds = @dir_event.event_registrations.sum('refund_amount', :conditions => @cancel_conds)
            @cancel_net = @cancel_costs - @cancel_refunds
            @reg_conds = ["processed = true and created_at > ? and  created_at < ?", start_time, end_time]
            @pay_conds =["date > ? and  date < ?", start_time, end_time]
            @orders = @dir_event.orders_by_time(start_time, end_time)
        end
	end
end
