class Feature < ActiveRecord::Base
	has_attached_file :image, :styles => { :thumb => "120x170>"},
        :url  => "/assets/features/:id/:style/:basename.:extension",
        :path => ":rails_root/public/assets/features/:id/:style/:basename.:extension"
end
