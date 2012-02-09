class AddEventTypesOther < ActiveRecord::Migration
  def self.up
    
    event_type = EventType.new()
    event_type.name = "other"
    event_type.discipline = Discipline.find_by_name("Running")
    event_type.save!
    
    event_type = EventType.new()
    event_type.name = "other"
    event_type.discipline = Discipline.find_by_name("Cycling")
    event_type.save!
    
    event_type = EventType.new()
    event_type.name = "other"
    event_type.discipline = Discipline.find_by_name("Multisport")
    event_type.save!
  end

  def self.down
  end
end
