class CreateContactInfos < ActiveRecord::Migration
  def self.up
    create_table :contact_infos do |t|
    	
	    t.string   "name"
	    t.string   "email"
	    t.string   "phone"
	    t.string   "state"
	    t.string   "city"
	    t.string   "zip"
	    t.string   "address"
	    
      t.timestamps
    end
  end

  def self.down
    drop_table :contact_infos
  end
end
