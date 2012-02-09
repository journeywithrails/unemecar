class AddExtraRegsToReg < ActiveRecord::Migration
  def self.up
  	add_column :event_registrations, :extra_regs, :string
  end

  def self.down
  end
end
