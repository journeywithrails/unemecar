class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
    	t.column :question_id, :integer
		t.column :question_option_id, :integer
		t.column :extra_info, :string
		
      t.timestamps
    end
    #add question type to question
    add_column :questions, :question_type, :int
  end

  def self.down
    drop_table :answers
  end
end
