class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.text :description
      t.integer :presentation_type_id
      t.integer :location_id
      t.integer :track_id
      t.integer :conference_id
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
