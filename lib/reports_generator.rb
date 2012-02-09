class ReportsGenerator
  require 'spreadsheet'
  require 'fastercsv'
  
  REG_STD_FORMAT = 1
  REG_RES_FORMAT = 2
  
  def self.create_reg_spreadsheet(event, options, start_time=nil, end_time=nil)
  	# load the data according to the options
  	conds = ["processed = true"]
  	
  	#see if we need to process a single category
  	unless options[:race].blank?
  		conds[0] += " AND race_id = ?"
  		conds << options[:race]
  	end
  	
  	if options[:sort_type] == "Last Name"
  		sort = "last_name ASC"
  	else
  		sort = "created_at ASC"
  	end
  	
  	if options[:reg_type] == "Online Entries Only"
  		conds[0] += " AND is_manual IS NOT true"
  	elsif options[:reg_type] == "Manual Entries Only"
  		conds[0] += " AND is_manual = true"
  	end
  	
  	
  	
  	
  	#handle time only if we need to
  	if options[:dates][0].to_i == 2
	  	unless start_time.nil?
	  		st = Date.parse(start_time) 
	  		conds[0] += " AND created_at > ?"
	  		conds << st
	  	end
	  	
	  	#handle time
	  	unless end_time.nil?
	  		et = Date.parse(end_time) 
	  		conds[0] += " AND created_at < ?"
	  		conds << et
	  	end
	end
  	
  	@regs = event.event_registrations.find(:all, :conditions => conds, :order => sort)
  	
  	if options[:format][0].to_i == REG_RES_FORMAT
  		csv_data = FasterCSV.generate do |csv|
			    csv << [
			    "Bib",
			    "First Name",
			    "Last Name",
			    "Sex",
				"Age",
			    "Team",
			    "City",
			    "State"]
			    @regs.each do | reg |
			    	team_str = ""
  					team_str = reg.team.name unless reg.team.blank?
  					if reg.team_entry.nil? == false and  reg.team_entry.team.nil? == false
  					  team_str = reg.team_entry.team.name
  					end
			    	csv << [
				      reg.bib_number,
				      reg.first_name,
				      reg.last_name,
				      reg.sex,
				      EventRegistration.race_age(reg.birthday, reg.race.start_time),
				      reg.club_team,
				      reg.city,
				      reg.state
				      ]
				end
		end
  	else #use STD format
  		csv_data = FasterCSV.generate do |csv|
  				arr = ["Category","Bib","First Name","Last Name","Sex","Age on Event Date", "DOB", "T-shirt", "Team","Address","City","State", "Country", "Zip","Phone","Email","Timestamp (UTC)","License", "Amount Paid", "Referral","Contact Name","Contact Phone","Contact Relationship","Manual Entry"]
  				
  				#add age on the end of the year if its tri or cycling
  				if event.is_tri_event
  					arr << "Age on 12/31/2010"
  				end
  				#custom questions support
  				event.questions.each do |question| 
					arr << question.title 
				end
				
  				if event.id == 5226 or event.id == 5238 or event.id == 5239
  					arr << "First Tri?"
  					arr << "First Open Water?"
  				end
  				if event.id == 5226 or event.id == 5238 or event.id == 5239 or event.id == 6426 or event.id == 6894
  					#hack - show team info as well
  					arr << "Team Name"
                    arr << "Entry #1"
                    arr << "Entry #1 info"
  					arr << "Entry #1 emergency contact"
  					arr << "Entry #2"
                    arr << "Entry #2 info"
  					arr << "Entry #2 emergency contact"
  					arr << "Entry #3"
                    arr << "Entry #3 info"
  					arr << "Entry #3 emergency contact"
  				end
  				#hack for Thurston
  				if event.id == 6894 
  					#hack - show team info as well
  					arr << "Entry #4"
            arr << "Entry #4 info"
  					arr << "Entry #4 emergency contact"
  					arr << "Entry #5"
            arr << "Entry #5 info"
  					arr << "Entry #5 emergency contact"
  					arr << "Entry #6"
            arr << "Entry #6 info"
  					arr << "Entry #6 emergency contact"
  					arr << "Entry #7"
            arr << "Entry #7 info"
  					arr << "Entry #7 emergency contact"
  					arr << "Entry #8"
            arr << "Entry #8 info"
  					arr << "Entry #8 emergency contact"
  					arr << "Entry #9"
            arr << "Entry #9 info"
  					arr << "Entry #9 emergency contact"
  					arr << "Entry #10"
            arr << "Entry #10 info"
  					arr << "Entry #10 emergency contact"
  				end
  				
  				#generic relay team DL support
  				
  				if event.needs_relay_team
  					arr << "Team Name"
  					max = event.races.find(:first, :order => "max_relay_size DESC").max_relay_size
  					min = event.races.find(:first, :order => "min_relay_size ASC").min_relay_size
  					(1..max).each do |i|
						arr << "Entry ##{i}"
            arr << "Entry ##{i} info"
  					arr << "Entry ##{i} emergency contact"
					end
  				end

			    csv << arr
			    @regs.each do | reg |
			    	
  					res_array = [reg.race.name, reg.bib_number, reg.first_name, reg.last_name, reg.sex,	EventRegistration.race_age(reg.birthday, reg.race.start_time), reg.birthday.strftime("%Y-%m-%d"), reg.tshirt, reg.club_team, reg.address + " " + reg.apt, reg.city, reg.state, reg.country, reg.zip,
				      reg.phone, reg.email, reg.created_at.strftime("%Y-%m-%d %I:%M%p %Z"), reg.license_num, reg.cost, reg.refered_by, reg.em_con_name, reg.em_con_phone,
				      reg.em_con_relationship, reg.is_manual]
				      
				    if reg.event.is_tri_event
  						res_array << EventRegistration.year_end_age(reg.birthday, reg.race.start_time)
  					end
				      
				    #custom questions support
  					reg.event.questions.each do |question| 
						answers = reg.answers.find( :all, :conditions => { 'question_id' => question.id } )
						res_array << answers.map{ |a| a.value }.join( ', ' )
					end 
            		#specific for Bill's events
				    if event.id == 5226 or event.id == 5238 or event.id == 5239
  						res_array << reg.first_tri
  						res_array << reg.open_swim
  					end
  					if event.id == 5226 or event.id == 5238 or event.id == 5239 or event.id == 6426 or event.id == 6894
              unless reg.relay_team.nil?
                res_array << "#{reg.relay_team.name} (#{reg.relay_team.division})"
                reg.relay_team.relay_entries.each do | entry |
                    res_array << "#{entry.first_name} #{entry.last_name} (#{entry.email})"
                    res_array << "#{entry.gender}, license: #{entry.license_num}, tshirt: #{entry.tshirt}, age:#{EventRegistration.race_age(entry.date_of_birth, reg.race.start_time)}"
                    res_array << "#{entry.em_con_name} #{entry.em_con_phone}"
                end
              end
            else
              unless reg.relay_team.nil?
                res_array << "#{reg.relay_team.name} (#{reg.relay_team.division})"
                reg.relay_team.relay_entries.each do | entry |
                    res_array << "#{entry.first_name} #{entry.last_name} (#{entry.email})"
                    res_array << "#{entry.gender}, license: #{entry.license_num}, tshirt: #{entry.tshirt}, age:#{EventRegistration.race_age(entry.date_of_birth, reg.race.start_time)}"
                    res_array << "#{entry.em_con_name} #{entry.em_con_phone}"
                end
              end
  					end
  					  					
			    	csv << res_array
				     
				end
			end
  	end
  	
  	#workbook.write(data)
  	csv_data
  	
  end
  
  def self.create_merch_spreadsheet(event, options, start_time=nil, end_time=nil)
  	#get the orders
  	
  	@merchs_c = event.merchandise_orders
  	@merchs = Array.new
  	@merchs_c.each {|mrc| @merchs << mrc if mrc.event_registration.processed == true}
  	#@merchs = 
  	csv_data = FasterCSV.generate do |csv|
			    csv << [
			    "Order ID",
			    "Registration ID",
			    "First Name",
			    "Last Name",
			    "Address",
			    "City",
			    "State",
			    "Zip",
			    "Country",
			    "Item",
				  "Quantity",
			    "Timestamp"]
			    @merchs.each do | merch |
			    	
			    	csv << [
				      merch.event_registration.invoice_code,
				      merch.event_registration.id,
				      merch.event_registration.first_name,
				      merch.event_registration.last_name,
				      merch.event_registration.address,
				      merch.event_registration.city,
				      merch.event_registration.state,
				      merch.event_registration.zip,
				      merch.event_registration.country,
				      "#{ merch.merchandise_item_option.merchandise_item.title } - #{merch.merchandise_item_option.title}",
				      merch.quantity,
				      merch.created_at.strftime("%Y-%m-%d %I:%M%p %Z")
				      ]
				end
		end
		csv_data
  end
  
  def self.csv_bill
    @regs = EventRegistration.find(:all, 
      :conditions => "(processed = true OR status = 'Trash') and (is_manual = false or is_manual IS NULL) and event_id IN (5239, 5226, 5238, 7078)", 
      :order => "event_id ASC")
    FasterCSV.open("#{RAILS_ROOT}/export_b.csv", "w") do |csv|
			    csv << [
			    "Event ID",
			    "Reg ID",
			    "Timestamp",
			    "First Name",
				  "Last Name",
				  "Email",
				  "Amount Paid",
				  "Service Fee",
			    "Cancellation Date"]
			    @regs.each do | reg |
			    	
			    	csv << [
				      reg.event_id,
				      reg.id,
				      reg.created_at.strftime("%Y-%m-%d %I:%M%p %Z"),
				      reg.first_name,
				      reg.last_name,
				      reg.email,
				      reg.cost,
				      reg.service_fee,
				      reg.status == "Trash" ? reg.updated_at.strftime("%Y-%m-%d %I:%M%p %Z") : ""
				      ]
				end
		end
		true
  end
end