class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string  :name
      t.date    :date
      t.integer :conference_id
      t.integer :location_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
