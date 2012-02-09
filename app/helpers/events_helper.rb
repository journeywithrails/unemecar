module EventsHelper
	#header is the name of the sort parameter, that appears in the header as well
	def show_sort_image(header)
		sort = params[:sort]
		ctrl = request.path_parameters['controller']
		act = request.path_parameters['action']
		if sort.nil? or sort.index(header).nil?
			#show the regular image, and set the link url to be sort DESC
			link_to image_tag('/images/img-inner/sort-arrows.png', :border => 0), params.merge(:sort => "#{header} DESC")
		else
			if sort == "#{header} DESC"
				#show the sort dESC image, and link to sort ASC
				link_to image_tag('/images/img-inner/sort-arrows_f2.png', :border => 0), params.merge(:sort => "#{header} ASC")
			else
				#show the sort ASC image, and link to sort DESC
				link_to image_tag('/images/img-inner/sort-arrows_f3.png', :border => 0), params.merge(:sort => "#{header} DESC")
			end
		end
		
	end
	
	def show_sort_text(text, header)
		sort = params[:sort]
		ctrl = request.path_parameters['controller']
		act = request.path_parameters['action']
		if sort.nil? or sort.index(header).nil?
			#show the regular image, and set the link url to be sort DESC
			link_to text, params.merge(:sort => "#{header} DESC")
		else
			if sort == "#{header} DESC"
				#show the sort dESC image, and link to sort ASC
				link_to text, params.merge(:sort => "#{header} ASC")
			else
				#show the sort ASC image, and link to sort DESC
				link_to text, params.merge(:sort => "#{header} DESC")
			end
		end
		
	end
	
	def show_event_type_info(event)
		if event.event_types.size > 1
			return show_tooltip("multiple", event.event_types_as_cs_string)
		elsif event.event_types.size == 1
			return event.event_types[0].name
		end
	end
	
	def show_event_type_search_as_string(search_req)
		if search_req.nil? == false
			if search_req["types"].nil?
				"Sport"
			elsif search_req["types"].size > 1
				"Multi"
			elsif search_req["types"].size == 1
				EventType.find(search_req["types"][0].to_i).name
			end
		else
			"Sport"
		end
	end
	
		
end
