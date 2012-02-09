class MerchandiseOrder < ActiveRecord::Base
	belongs_to :merchandise_item_option
	belongs_to :event_registration

  def item_cost
    return 0.00 if merchandise_item_option.nil? || merchandise_item_option.cost.nil?
    merchandise_item_option.cost * quantity
  end
  
  
end
