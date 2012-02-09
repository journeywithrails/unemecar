module EventHelper
	
  
  
  def header_image(event)
		return unless event
		if event.header_image
			image_tag( event.header_image.file.url, :border => 0, :width => 728, :height => 90 )
		elsif event.id == 4621
			image_tag('hinghamturkeytrotbanner_03.gif', :border => 0)
		elsif event.id == 4622
			image_tag('h5k_header.png', :border => 0)
		#elsif event.id == 5239
		#	image_tag('marlborough_650x90.jpg', :border => 0)
		#elsif event.id == 5226
		#	image_tag('cohasset_650x90.jpg', :border => 0)
		#elsif event.id == 5238
		#	image_tag('nantucket_650x90-1.jpg', :border => 0)
		elsif (event.id == 5261 or event.id == 5238 or event.id == 5226 or event.id == 5239)
			image_tag('comm_tri.jpg', :border => 0)
		else
			image_tag('header_idea.jpg', :border => 0)
		end
	end
  
  
  

    def show_age_group(age)
        if age < 19
            "18 & under"
        elsif age < 30
            "19-29"
        elsif age < 40
            "30-39"
        elsif age < 50
            "40-49"
        elsif age < 60
            "50-59"
        elsif age < 70
            "60-69"
        else
            "70+"
        end
    end
    
    def event_keywords(event)
      res = ""
      event.name.split(' ').each do |token|
        res += token + ", "
      end
      res
    end
end
