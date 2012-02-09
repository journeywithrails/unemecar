module Director::SummaryHelper
    def show_activity_selector_all(type)
        if type.nil?
            "Total"
        else
            link_to "Total", :action => "index"
        end
    end

    def show_activity_selector_day(type)
        if type.nil? == false and type == "day"
            "24 hours"
        else
            link_to "24 hours",  :action => "index", :activity => "day"
        end
    end
    
    def show_activity_selector_week(type)
         if type.nil? == false and type == "week"
            "7 days"
        else
            link_to "7 days",  :action => "index", :activity => "week"
        end
    end

    def show_activity_selector_month(type)
         if type.nil? == false and type == "month"
            "30 days"
        else
            link_to "30 days", :action => "index", :activity => "month"
        end
    end
end
