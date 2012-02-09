class AddBirthdayToWaitlists < ActiveRecord::Migration
  def self.up
    add_column :waitlists, :birthday, :date
	remove_column :waitlists, :age
  end

  def self.down
    remove_column :waitlists, :birthday
	add_column :waitlists, :age, :string
  end
end
