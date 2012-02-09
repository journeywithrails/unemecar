class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :event_id
      t.integer :race_id
      t.date :expire_at
      t.date :used_at, :default => nil
      t.string :email
      t.string :secret

      t.timestamps
    end
    add_column :watchlists, :is_invited, :boolean
  end

  def self.down
    drop_table :invitations
    remove_column :watchlists, :is_invited
  end
end
