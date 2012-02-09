class FixNilEventTypes < ActiveRecord::Migration

  # assign the event type to the event
  def self.set(date_string, event_name, discipline, event_type_name)
    date = DateTime.parse(date_string)
    event = Event.find(:first, :conditions => {:name => event_name, :event_date => date.to_s})
    event_type = EventType.find(:first, :conditions => {:name => event_type_name, :discipline_id => discipline.id})
    raise "event is nil! #{date_string} #{event_name}" if (event.nil?)
    raise "event_type is nil! #{event_type_name}" if (event_type.nil?)
    event.event_types << event_type if !event.event_types.include?(event_type)
  end

  # remove
  def self.rem(date_string, event_name)
    date = DateTime.parse(date_string)
    event = Event.find(:first, :conditions => {:name => event_name, :event_date => date.to_s})
    if (event.nil?)
      puts "[warning] event is nil! #{date_string} #{event_name}" 
    else
      Event.destroy(event.id)
    end
  end

  def self.up

    running = Discipline.find_by_name("Running")
    cycling = Discipline.find_by_name("Cycling")
    multisport = Discipline.find_by_name("Multisport")

   
   
   
   
   
     set("07/30/2009", "Jerry Garcia Memorial River Run-Walk & Deadfest", running, "other")
      set("05/02/2009", "2009 ATLANTIC 10 OUTDOOR TRACK AND FIELD CONFERENCE CHAMPIONSHIP", running, "other")
      rem("06/28/2009", "The Ridges Invitational 5k Open Water Swim")
      set("05/09/2009", "Lake Wobegon Trail Marathon", running, "marathon")
      set("05/09/2009", "Lake Wobegon Trail Marathon", running, "trail run")
      set("05/09/2009", "Lake Wobegon Trail Marathon", running, "other")
      set("01/10/2010", "5th Annual Red Nose Run", running, "other")
      set("05/02/2009", "2009 Napa Valley Vintage Half-Iron Triathlon", multisport, "tri: half-ironman")
      set("01/03/2009", "RCC Tiger Invitational", running, "other")
      set("01/03/2009", "Boston U Developmental Meet #3", running, "other")
      set("01/04/2009", "Cape Cod Road Runners Winter Fun Run", running, "other")
      set("01/11/2009", "Khoury's Winter Challenge", running, "other")
      set("01/18/2009", "MSTCA Division 4 State Relays", running, "other")
      set("01/25/2009", "Colonial Winter Series", running, "other")
      set("02/01/2009", "Colonial Winter Series", running, "other")
      set("02/07/2009", "4th Run Up Boston Place", running, "other")
      set("02/07/2009", "2009 Sleigh Bell Road Race", running, "other")
      set("02/08/2009", "MSTCA \"Bob McIntyre\" New England Relays", running, "other")
      set("02/14/2009", "Greater Boston League Indoor T&F Championship", running, "other")
      set("02/14/2009", "Harvard - Yale - Princeton Track Meet", running, "other")
      set("02/14/2009", "Dual County League T&F Championship", running, "other")
      set("02/14/2009", "Hockomcok League T&F Championship", running, "other")
      set("02/14/2009", "31st Annual District E Indoor Invitational Track & Field Meet", running, "other")
      set("02/21/2009", "New England Division 3 Collegiate Indoor T&F Champ's", running, "other")
      set("02/21/2009", "MIAA Division 1 Track & Field Championship", running, "other")
      set("02/21/2009", "MIAA Div IV Track & Field Champhionships", running, "other")
      set("02/22/2009", "MIAA Division 2 Track & Field Championship", running, "other")
      set("02/22/2009", "2009 USATF New England Indoor Championship", running, "other")
      set("02/28/2009", "Hawley Kiln", running, "other")
      set("02/28/2009", "NEICAAA New England Championships", running, "other")
      set("03/07/2009", "NEPVC Invitational", running, "other")
      set("03/07/2009", "ECAC Div 1 Women's Track & Field Championships", running, "other")
      set("03/07/2009", "ECAC DIII Track & Field Championships", running, "other")
      set("03/08/2009", "ECAC Division I Women's Indoor Track & Field Championships", running, "other")
      set("03/21/2009", "Husky Spring Open", running, "other")
      set("03/22/2009", "26th James H. Lamb Memorial Scholarship Road Race", running, "other")
      set("03/28/2009", "Tufts - Snowflake Invitational", running, "other")
      set("03/28/2009", "Worcester City Championship Meet", running, "other")
      set("04/04/2009", "Engineer's Cup 2009", running, "other")
      set("04/04/2009", "Jim Sheehan Memorial Invitaional 2009", running, "other")
      set("04/04/2009", "12th Annual NDA Cup ", running, "other")
      set("04/11/2009", "University of Massachusetts Spring Meet", running, "other")
      set("04/11/2009", "Corsair Classic Track & Field Invitational", running, "other")
      set("04/11/2009", "Bernard Solomon Invitational", running, "other")
      set("04/18/2009", "The College of the Holy Cross Quad Meet", running, "other")
      set("04/18/2009", "Fitchburg State Spring Invitational Track & Field Meet", running, "other")
      set("04/18/2009", "15th NDA Rt 228 F/S Track & Field Invitational", running, "other")
      set("04/19/2009", "Heartbreak Hill Youth Events", running, "other")
      set("02/15/2009", "Monta", running, "other")
      set("03/07/2009", "2009 SCIAC Track & Field Invitational", running, "other")
      set("03/28/2009", "NAPA VALLEY TRAIL MARATHON, HALF MARATHON & 10K", running, "other")
      set("01/04/2009", "2009 January Indoor Track Meet Results", running, "other")
      set("01/18/2009", "USATF Indoor Developmental 2 Meet 2009", running, "other")
      set("02/14/2009", "CHSAA Indoor Championships 2009", running, "other")
      rem("01/25/2009", "")
      set("03/21/2009", "Darcy", running, "other")
      set("02/22/2009", "Hustle Up the Hancock 2009", running, "other")
      set("01/04/2009", "Sunday Indoor Track Meets 2009", running, "other")
      set("01/18/2009", "DCRRC / PVTC Indoor Track Meet 2009", running, "other")
      set("02/28/2009", "Virginia AA Indoor State Championships 2009", running, "other")
      set("03/21/2009", "James Madison University Track Invitational 2009", running, "other")
      set("03/21/2009", "USA Masters Indoor Track & Field Championships", running, "other")
      rem("01/01/2009", "New Year")
      set("02/22/2009", "Princeton Invitational 2009", running, "other")
      set("02/07/2009", "2009 USA Cross Country Championships", running, "other")
      set("03/21/2009", "2009 USA Masters Indoor Track & Field Championships", running, "other")
      set("02/07/2009", "NB/SJJ WINTER GRAND PRIX 2008-09 ", running, "other")
      set("03/15/2009", "NW Trail Run - Des Moines Creek Park 2009", running, "trail run")
      set("04/19/2009", "2009 Komen Eastern Washington Race for the Cure", running, "other")
      set("08/01/2009", "Half Vineman AquaBike", running, "other")
      set("08/01/2009", "Full Vineman AquaBike ", running, "other")
      rem("05/29/2009", "Great Hudson River Swim ")
      rem("06/06/2009", "Manhattan Island Marathon Swim ")
      rem("06/14/2009", "Park to Park Swim")
      rem("06/26/2009", "Liberty Island Swim ")
      rem("07/18/2009", "Riverside Park 1.5K Swim ")
      rem("09/04/2009", "Governors Island Swim ")
      rem("09/12/2009", "Brooklyn Bridge 1K Swim ")
      rem("09/26/2009", "Little Red Lighthouse Swim ")
      rem("10/17/2009", "Ederle Swim ")
      set("01/17/2009", "One Day Extreme", multisport, "adventure race")
      set("05/23/2009", "Wild Wonderful 24hr Adventure Race", multisport, "adventure race")
      set("05/31/2009", "Rehab To Racing Open Water Swim Training Venue", multisport, "other")
      set("06/12/2009", "Equinox Traverse Expedition Adventure Race", multisport, "adventure race")
      rem("07/11/2009", "Chris Greene Lake 1- & 2-Mile Swim")
      set("07/12/2009", "Rehab To Racing Open Water Swim Training Venue", multisport, "other")
      set("07/25/2009", "One Day Adventure Race", multisport, "adventure race")
      set("09/12/2009", "Little-Big Adventure", multisport, "other")
      set("06/14/2009", "Wendy", multisport, "other")
      set("06/20/2009", "Lovelands Amazing Race", running, "other")
      set("07/11/2009", "Headwaters Adventure Race", multisport, "adventure race")
      set("05/16/2009", "Urban Dare Pittsburgh", multisport, "adventure race")
      set("05/09/2009", "Lake Wobegon Trail Marathon", running, "trail run")
      set("05/09/2009", "Lake Wobegon Trail Marathon", running, "marathon")
      set("06/07/2009", "NipMuck Trail Marathon", running, "trail run")
      set("06/07/2009", "NipMuck Trail Marathon", running, "marathon")
      set("09/17/2009 15:30:01", "Thompson Island 4k Trail Run", running, "trail run")
   
  end

  def self.down
  end
end
