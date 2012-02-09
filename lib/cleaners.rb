class Cleaners
  
  #rr = EventRegistration.count(:all, :conditions => "processed = true and cost IS NULL", :group => "race_id")
  
  
  def self.clean_null_cost
    
    clean_n_c(8046, 20, 2.5) #
    clean_n_c(8228, 25, 2.5) #
    clean_n_c(8014, 15, 2.5) #
    clean_n_c(7948, 10, 2.5) #
    clean_n_c(7673, 20, 2.5) #
    clean_n_c(8350, 20, 2.5) #
    clean_n_c(8229, 25, 2.5) #
    clean_n_c(7921, 80, 5)   #
    clean_n_c(8307, 25, 2.5) #
    clean_n_c(7988, 20, 2.5) #
    #clean_n_c(4507, 20, 2.5) 
    clean_n_c(8046, 20, 2.5) #
    clean_n_c(8297, 25, 2.5) #
    clean_n_c(7945, 20, 2.5) #
    #clean_n_c(4843, 20, 2.5) #
    clean_n_c(8017, 20, 2.5) #
    clean_n_c(7874, 25, 2.5) # 
    clean_n_c(8265, 18, 2.5) #
    clean_n_c(7957, 20, 2.5) #
  end
  
  def self.clean_n_c(race_id, new_cost, new_sfee)
    puts "cleaning race #{race_id}...\n"
    r = Race.find(race_id)
    counter = 0
    r.event_registrations.processed.find(:all, :conditions => "cost IS NULL").each do |er|
      er.cost = new_cost
      er.service_fee = new_sfee
      er.save(false)
      counter += 1
    end
    puts "--- #{counter} cleaned.\n"
  end
end