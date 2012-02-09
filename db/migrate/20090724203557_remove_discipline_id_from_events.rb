class RemoveDisciplineIdFromEvents < ActiveRecord::Migration
  def self.up
    
    # I decided to get this done in a later migration because other migrations need to happen first
    
    #remove_column :events, :discipline_id
  end
  def self.down
    #add_column :events, :discipline_id, :integer
  end
end
