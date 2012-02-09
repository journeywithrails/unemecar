class AddPresentedAndBenefitToEvent < ActiveRecord::Migration
  def self.up
  	add_column :events, :presented_by, :string
  	add_column :events, :benefiting, :string
  	
  end

  def self.down
  end
end
