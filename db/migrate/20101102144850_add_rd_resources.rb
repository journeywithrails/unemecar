class AddRdResources < ActiveRecord::Migration
  def self.up
    Content.create :name => "rd resources"
  end

  def self.down
  end
end
