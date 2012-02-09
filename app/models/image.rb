class Image < ActiveRecord::Base

  has_attached_file :file,:styles => { :small => "150x150>", :medium => "300x300>", :thumb => "100x100>" },
                  :url  => "/assets/images/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/images/:id/:style/:basename.:extension"

end
