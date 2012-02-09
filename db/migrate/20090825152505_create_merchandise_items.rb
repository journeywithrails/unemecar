class CreateMerchandiseItems < ActiveRecord::Migration
  def self.up
    create_table :merchandise_items do |t|
		t.column :event_id, :integer
		t.column :is_donation, :boolean
		t.column :title, :string
		t.column :description, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :merchandise_items
  end
end
