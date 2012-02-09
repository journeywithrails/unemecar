class AddFbUsidToDirectorRequest < ActiveRecord::Migration
  def self.up
      add_column :director_requests, :fb_id, :string
  end

  def self.down
  end
end
