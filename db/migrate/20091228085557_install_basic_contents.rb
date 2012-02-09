class InstallBasicContents < ActiveRecord::Migration
  def self.up
    Content.create :name => "about us"
    Content.create :name => "rd services"
    
  end

  def self.down
  end
end
