class CreateRelayEntries < ActiveRecord::Migration
  def self.up
    create_table :relay_entries do |t|
		t.column :event_registration_id, :integer
		t.column :first_name, :string
		t.column :last_name, :string
		t.column :em_con_name, :string
		t.column :em_con_phone, :string
		t.column :is_captain, :boolean
		t.column :rm_user_id, :int
		t.column :team_order, :int
      t.timestamps
    end
    add_column :races, :is_relay, :boolean
    add_column :races, :min_relay_size, :int
    add_column :races, :max_relay_size, :int
  end

  def self.down
    drop_table :relay_entries
  end
end
