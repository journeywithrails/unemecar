class Series < ActiveRecord::Base
  
  has_attached_file :header,:styles => { :small => "150x150>", :medium => "300x300>", :thumb => "100x100>" },
                   :url  => "/assets/series/:id/:style/:basename.:extension",
                   :path => ":rails_root/public/assets/series/:id/:style/:basename.:extension"
  
  validates_presence_of :name,:description
end
