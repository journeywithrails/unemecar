class CreateRedirects < ActiveRecord::Migration
  def self.up
    create_table :redirects do |t|
      t.column :text, :string
      t.column :url, :string
      

      t.timestamps
    end
  end

  def self.down
    drop_table :redirects
  end
end
