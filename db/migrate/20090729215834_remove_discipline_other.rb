class RemoveDisciplineOther < ActiveRecord::Migration
  def self.up
    Discipline.delete(Discipline.find_by_name("Other"))
  end

  def self.down
  end
end
