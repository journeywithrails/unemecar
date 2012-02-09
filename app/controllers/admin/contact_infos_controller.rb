class Admin::ContactInfosController < ApplicationController
	
	before_filter :verify_login
	layout "admin"
	active_scaffold :contact_info do |config|
		config.columns = [:name, :email, :address, :city, :state, :zip, :phone, :show_address, :show_phone, :show_name, :show_email]
	end
end
