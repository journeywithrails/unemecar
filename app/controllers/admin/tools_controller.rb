class Admin::ToolsController < ApplicationController
	require 'fastercsv'
	layout "admin"
	before_filter :verify_login
	
	def export
		if request.post?
			#get the form params, and search registrations
			conds = ['processed = ?', true]
			search_req = params[:export_e]
			unless search_req.nil?
				unless search_req[:city].blank?
					conds[0] = conds[0] + " AND city = ?"
					conds << search_req[:city]
				end		    
				unless search_req[:state].blank?
					conds[0] = conds[0] + " AND state = ?"
					conds << search_req[:state]
				end
				unless search_req[:zip].blank?
					conds[0] = conds[0] + " AND zip = ?"
					conds << search_req[:zip]
				end
				@regs = EventRegistration.find(:all, :conditions => conds, :order => "last_name")
			
				csv_data = FasterCSV.generate do |csv|
				    csv << [
				    "First Name",
				    "Last Name",
				    "Email",
					"Date of Birth",
				    "Sex",
				    "City",
				    "State",
				    "Zip"
			    ]
				    @regs.each do | reg |
				    	
				    	csv << [
					      reg.first_name,
					      reg.last_name,
					      reg.email,
					      reg.birthday,
					      reg.sex,
					      reg.city,
					      reg.state,
					      reg.zip
					      ]
					end
				end
				send_data(csv_data, :type => "text/csv", :disposition => 'attachment', :filename => "email_export.csv")
			
					
			end
			
			
		end
	end
end
