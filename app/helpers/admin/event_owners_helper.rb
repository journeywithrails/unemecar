
module Admin::EventOwnersHelper
	
	def rm_user_id_column(record)
		return "nil" if record.owner.nil?
		record.owner.identification_name
	end
  
    def event_id_column(record)
      return "nil" if record.new_record? 
      Event.find(record.event_id).try(:name)
    end

	def event_id_form_column(record, input_name)
		record.event.name + hidden_field(  :record, :event_id )
	end
     
	def rm_user_id_form_column(record, input_name)
	  belongs_to_auto_completer :record, :owner, :name, { :controller => 'rm_users', :action => :autocomplete_search }, { :size => 30, :class => 'event_id-input text-input' }
	end

end


