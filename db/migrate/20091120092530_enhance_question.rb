class EnhanceQuestion < ActiveRecord::Migration
  def self.up
  	add_column :questions, :explanation_text, :string
  	add_column :answers, :event_registration_id, :int
  end

  def self.down
  end
end
