class Admin::CancellationsController < ApplicationController
	before_filter :verify_login
	layout "admin"
	active_scaffold :event_registration do |config|
	    config.list.columns = [:first_name, :last_name, :event, :race, :email, :cost, :refund_amount, :refund_processed, :event_id, :id, :invoice_code]
	    #config.create.columns = [:name, :image, :feature_order, :link, :visible]
	    config.update.columns = [:refund_amount, :refund_processed]
        config.label = "Cancellations"
        config.actions.exclude :create, :delete
        
	end
	
	def conditions_for_collection
  		["status = 'Trash'"]
	end
end
