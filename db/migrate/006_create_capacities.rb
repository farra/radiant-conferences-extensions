class CreateCapacities < ActiveRecord::Migration
  def self.up
    create_table :capacities do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :capacities
  end
end
