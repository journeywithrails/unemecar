class RaceGroup < ActiveRecord::Base
	has_many :races, :order => :race_group_order
	belongs_to :event
	validates_uniqueness_of :title, :scope => :event_id
end
