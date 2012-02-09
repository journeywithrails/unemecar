class Team < ActiveRecord::Base
	  belongs_to :event
	  validates_presence_of     :name

    attr_protected :id, :event_id, :approved, :race_director_id
    has_many :team_entries

    def name_with_type
        "#{name} (#{team_type})"
    end
end
