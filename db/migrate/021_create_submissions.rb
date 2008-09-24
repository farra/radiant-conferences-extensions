class CreateSubmissions < ActiveRecord::Migration
  def self.up
    create_table :submissions do |t|
      t.integer :presentation_id
      t.integer :conference_id
      t.boolean :reviewed
      t.boolean :accepted
      t.integer :score
      t.integer :votes

      t.timestamps
    end
  end

  def self.down
    drop_table :submissions
  end
end
