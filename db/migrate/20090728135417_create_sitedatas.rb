class CreateSitedatas < ActiveRecord::Migration
  def self.up
    create_table :sitedatas do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :sitedatas
  end
end
