class Admin::EventPaymentsController < ApplicationController
    before_filter :verify_login
	layout "admin"
	active_scaffold :event_payment do |config|
	    config.list.columns = [:date, :amount, :check_number]
	    config.create.columns = [:date, :amount, :check_number, :notes]
	    config.update.columns =  [:date, :amount, :check_number, :notes]

	end
end
