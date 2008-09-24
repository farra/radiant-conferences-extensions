class CreateSponsors < ActiveRecord::Migration
  def self.up
    create_table :sponsors do |t|
      t.integer :conference_id
      t.integer :person_id
      t.integer :sponsor_type_id
      t.integer :sponsor_class_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sponsors
  end
end
