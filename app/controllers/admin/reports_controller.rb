class Admin::ReportsController < ApplicationController
    before_filter :verify_login
	layout "admin"

    def index
        #rconds =  ["processed = true and (is_manual IS NULL or is_manual = false) and event_id IN (5776, 5802, 4621, 4622, 4611, 4706, 5226, 5238, 5239)"]
        rconds = ["event_registrations.processed = true and (is_manual IS NULL or is_manual = false)"]
        #@num = EventRegistration.find(:all, :conditions =>rconds, :joins => "join event_registrations on event_registrations.event_id = events.id").size
        @num = EventRegistration.find(:all, :conditions =>rconds).size
        @sf = EventRegistration.sum('service_fee', :conditions =>rconds)
        @tc = EventRegistration.sum('cost', :conditions =>rconds)

        @svc_graph = open_flash_chart_object(600,600,"/admin/reports/sales?type=fee")
        @reg_graph = open_flash_chart_object(600,600,"/admin/reports/sales?type=reg")
    end

    def sales

        values = Array.new
		labels = Array.new
        latest = DateTime.now
        total = 0
        type = params[:type]
        (0..12).each do |i|
            date = latest - i.months
            labels.unshift date.strftime("%m-%y")

            sdate = Date.new(date.year, date.month, 1)
            edate = sdate + 1.month
            #rconds =  ["processed = true and (is_manual IS NULL or is_manual = false) and event_id IN (5776, 5802, 4621, 4622, 4611, 4706, 5226, 5238, 5239) and created_at BETWEEN ? AND ?", sdate, edate]
            rconds =  ["processed = true and (is_manual IS NULL or is_manual = false) and created_at BETWEEN ? AND ?", sdate, edate]
            if type == "fee"
                fee = @sf = EventRegistration.sum('service_fee', :conditions =>rconds)
                values.unshift fee
                total += fee
            elsif type == "reg"
                regs = @sf = EventRegistration.find(:all, :conditions =>rconds).size
                values.unshift regs
                total += regs
            end
        end
		
        
        x = XAxis.new
		x.set_offset(false)
		x.set_labels(labels)

		y = YAxis.new

        line_dot = LineDot.new
	    #
	    line_dot.width = 2
	    line_dot.colour = '#DFC329'
	    line_dot.dot_size = 3
	    line_dot.values = values

        if type == "fee"
            title = "Total Service Fee Collected: $#{'%.2f' % total}"
            y.set_range(0,15000, 3000 )
            line_dot.text = "Service Fee (dollars)"
        elsif type == "reg"
            title = "Total Registrations: #{total}"
            y.set_range(0,5000, 1000 )
            line_dot.text = "number of registrations"
        end

	   



		title = Title.new(title)
	    #bar = BarGlass.new
	    #bar.set_values(values)
	    chart = OpenFlashChart.new
	    chart.set_title(title)
	    chart.add_element(line_dot)
	    chart.set_x_axis(x)
	    chart.set_y_axis(y)
	    render :text => chart.to_s
    end
end
