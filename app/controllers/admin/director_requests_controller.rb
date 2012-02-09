class Admin::DirectorRequestsController < ApplicationController
	before_filter :verify_login
	layout "admin"
	active_scaffold :director_request do |config|
        config.list.columns = [:event_date, :name, :city, :state, :contact_name, :contact_email, :created_at, :fb_id]
        config.action_links.add 'convert_to_event', :label => 'Convert to Event ',:action => 'convert_to_event', :popup => true, :type => :record
        config.columns << "fb_id"
	end

  def convert_to_event
    @dir_req = DirectorRequest.find(params[:id])
    @dir_req.convert_to_event
    render :text => "#{@dir_req.name} added to calendar."
  end
end
