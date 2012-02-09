class HomeFeature < ActiveRecord::Base
    has_attached_file :image, :styles => { :thumb => "86x62>"},
        :url  => "/assets/home_features/:id/:style/:basename.:extension",
        :path => ":rails_root/public/assets/home_features/:id/:style/:basename.:extension"
end
