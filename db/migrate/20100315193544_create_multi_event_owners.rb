class CreateMultiEventOwners < ActiveRecord::Migration
  def self.up
    create_table :event_owners,:force => true do |t|
      t.integer :event_id, :null => false
      t.integer :rm_user_id, :null => false
    end
    
    Event.find(:all, :conditions => ['owner_id is not null']).each  do |event|
        user = RmUser.find(event.owner_id)
        user.managed_events << event unless user.managed_events.include?(event) 
    end
    
    remove_column :events, :owner_id
  end

  def self.down
    add_column :events, :owner_id, :integer
    drop_table :event_owners
  end
  
end
