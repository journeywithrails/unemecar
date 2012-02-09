class AddLastYearResToEv < ActiveRecord::Migration
  def self.up
    add_column :events, :last_year_results, :string
  end

  def self.down
    remove_column :events, :last_year_results
  end
end
