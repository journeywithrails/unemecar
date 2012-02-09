class RaceFeeChange < ActiveRecord::Base
  belongs_to :race, :class_name => "Race", :foreign_key => "race_id"
  attr_accessor :change_time, :_delete
  default_scope :order => 'change_date'
  
  def validate 
    errors.add_to_base("Please select future date") if change_date.nil? or change_date < Time.now
  end
  
end
