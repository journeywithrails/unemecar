class CreateWatchlists < ActiveRecord::Migration
  def self.up
    create_table :watchlists do |t|
      t.integer :event_id, :null => false
      t.integer :race_id, :null => false
      t.integer :rm_user_id, :null => false
      t.string :name
      t.string :age
      t.string :gender
      t.string :email
      t.text :address
      t.string :phone

      t.timestamps
    end
    add_column :races, :has_waiting_list, :boolean
  end

  def self.down
    drop_table :watchlists
    remove_column :races, :has_waiting_list
  end
end
