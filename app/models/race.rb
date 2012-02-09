class Race < ActiveRecord::Base
	belongs_to :event_type
	belongs_to :event
	belongs_to :race_group
	has_many :event_registrations
	has_many :manual_registrations, :class_name => "EventRegistration", :conditions => ['is_manual = true']
	has_many :online_registrations, :class_name => "EventRegistration", :conditions => ['is_manual = false or is_manual IS NULL']
	has_many :procssed_registrations, :class_name => "EventRegistration", :conditions => ['processed = true']
	has_many :race_merchandise_items
	has_many :merchandise_items, :through => :race_merchandise_items
	has_many :race_fee_changes
	named_scope :registerable, :conditions => 'registration_open IS NOT FALSE'
	acts_as_audited 
  
	DISTANCE_UNITS = ["km", "miles"]
	

	#TODO - return the correct fee according to the fee change rules
	def current_fee(req_date = Time.now)
	  fees = self.race_fee_changes.find(:first, :conditions => "UNIX_TIMESTAMP(change_date) < '#{req_date.to_i}'", :order => 'change_date DESC')
	  fee = fees.nil? ? self.initial_fee : fees.fee
	  '%.2f' % fee unless fee.blank?
	end
  
  def for_waiting_list?
    registration_open && registration_limit_reached? && has_waiting_list
  end
  
	def registration_limit_reached?
    	field_size && event_registrations.processed.size >= field_size
	end

	def registrations_by_time( time_start = '', time_end = nil )
		time_end = Time.now if time_end.nil?
		processed_registrations.find(:all, :conditions => ['created_at >= ? and created_at <= ?', time_start, time_end])
	end
  
  def after_create
        #if this race is not part of a race group, add it to the default one
        if race_group.nil?
            rg = event.race_groups.find(:first)
            unless rg.nil?
	            top = rg.races.find(:first, :order => "race_group_order DESC")
	            if top.nil?
	                rgo = 1
	            else
	                rgo = top.race_group_order.to_i + 1
	            end
	            
	            self.race_group = rg
	            self.race_group_order = rgo
	            save
	        end
        end
  end
	
	def validate
		errors.add_to_base("maximum relay team size cannot be smaller than minimum relay team size") if (is_relay and min_relay_size > max_relay_size)
		errors.add_to_base "please select race classification" if event_type_id.nil?
		errors.add_to_base("inconsistent event date: event date is #{event.event_date.strftime("%m/%d/%Y")}") if start_time.nil? or (start_time.strftime("%m/%d/%Y") != event.event_date.strftime("%m/%d/%Y"))
	end
	
	def needs_tri_disc
		if event_type_id == 14 or event_type_id == 15 or event_type_id == 16or event_type_id == 17 or event_type_id == 20
			true
		else
			false
		end
	end
	
	def string_desc
		sd = "#{name} ($#{current_fee})"
		if has_cap_left == false
			sd << " [Full]"
			sd << " [W/L]" if has_waiting_list
		elsif registration_open != true
			sd << " [Closed]"
			sd << " [W/L]" if has_waiting_list
		end
		sd
	end
	
	def has_cap_left
		return true if field_size.nil?
		return field_size > event_registrations.processed.size
	end

    def can_reg
		return false if registration_open != true
		return false if has_cap_left == false
        return true
    end
end
