class CreateQuestionOptions < ActiveRecord::Migration
  def self.up
    create_table :question_options do |t|
		t.column :question_id, :integer
		t.column :q_order, :integer
		t.column :title, :string
      t.timestamps
    end
    
    #rename the column
    rename_column :merchandise_item_options, :order, :o_order
  end

  def self.down
    drop_table :question_options
  end
end
