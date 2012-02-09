class AddEventTypes < ActiveRecord::Migration
  def self.up
    
    # add event type "adventure race"
    puts "adding event type 'adventure race'"
    if (EventType.find_by_name("adventure race").nil?)
      event_type = EventType.new()
      event_type.name = "adventure race"
      event_type.discipline = Discipline.find_by_name("Multisport")
      event_type.save!
    end

    # remove event types that begin with "tri: "
    puts "remove event types that begin with 'tri: '"
    sprint = EventType.find_by_name("tri: sprint")
    olympic = EventType.find_by_name("tri: olympic/int'l")
    half_ironman = EventType.find_by_name("tri: half-ironman")
    ironman = EventType.find_by_name("tri: ironman")
    EventType.destroy(sprint) if !sprint.nil?
    EventType.destroy(olympic) if !olympic.nil?
    EventType.destroy(half_ironman) if !half_ironman.nil?
    EventType.destroy(ironman) if !ironman.nil?

    # rename event types to add "tri: "
    puts "rename event types to add 'tri: '"
    sprint = EventType.find_by_name("sprint")
    olympic = EventType.find_by_name("olympic/int'l")
    half_ironman = EventType.find_by_name("half ironman")
    ironman = EventType.find_by_name("ironman")
    raise "[error] sprint nil!" if sprint.nil?
    raise "[error] olympic nil!" if olympic.nil?
    raise "[error] half_ironman nil!" if half_ironman.nil?
    raise "[error] ironman nil!" if ironman.nil?
    sprint.name = "tri: sprint"
    olympic.name = "tri: olympic/int'l"
    half_ironman.name = "tri: half-ironman"
    ironman.name = "tri: ironman"
    sprint.save!
    olympic.save!
    half_ironman.save!
    ironman.save!
    
  end

  def self.down
  end
end
