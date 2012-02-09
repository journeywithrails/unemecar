class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
		t.column :event_id, :integer
		t.column :is_required, :boolean
		t.column :title, :string
		t.column :q_order, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
