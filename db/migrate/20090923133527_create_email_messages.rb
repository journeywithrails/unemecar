class CreateEmailMessages < ActiveRecord::Migration
  def self.up
    create_table :email_messages do |t|
		t.column :event_id, :integer
		t.column :rm_user_id, :integer
		t.column :subject, :string
		t.column :content, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :email_messages
  end
end
