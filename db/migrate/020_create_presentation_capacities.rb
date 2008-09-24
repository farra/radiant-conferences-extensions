class CreatePresentationCapacities < ActiveRecord::Migration
  def self.up
    create_table :presentation_capacities do |t|
      t.integer :capacity_id
      t.integer :presentation_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :presentation_capacities
  end
end
